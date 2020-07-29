module Make (Cursor : CURSOR.S) = struct

  module Stage = Tape.Stage
  module Link = Tape.Head.Link
  
  type t = { cursor : Cursor.t;
               tape : Tape.t
           }

  let make cursor tape = { cursor; tape }
  let start tissue source =
    make (tissue |> Cursor.make)
         (source |> Tape.start)

  let cursor o = o.cursor
  let tape o = o.tape
                       
  let call_step call o =
    match Tape.Head.link o.tape with
    | Link.Start -> assert false
    | Link.Cell Statement.(Perform action) ->
       { o with cursor = Cursor.perform action o.cursor
       }
    | Link.Cell Statement.(Call (procedure, _)) ->
       let wait, find = Energy.find procedure call in
       let find = Stage.Find find in
       { o with tape = o.tape |> Tape.Head.set_wait wait
                              |> Tape.Head.change_stage find
       }
    | Link.Cell Statement.(Declare _)
    | Link.End -> 
       let back = Stage.Back (Energy.back call) in
       { o with tape = Tape.Head.change_stage back o.tape
       }
         
  let find_step find o =
    match Tape.Head.link o.tape with
    | Link.Start -> assert false
    | Link.Cell Statement.(Declare (procedure, _))
         when procedure = (Energy.Find.procedure find) ->
       let mark, call = Energy.call find in
       let call = Stage.Call call in
       { o with tape = o.tape |> Tape.Head.mark mark
                              |> Tape.Head.change_stage call
       }
    | Link.Cell Statement.(Perform _ | Call _ | Declare _) -> o
    | Link.End ->
       let back = Stage.Back (Energy.not_found find) in
       { o with tape = Tape.Head.change_stage back o.tape
       }

  let back_step back o =
    match Tape.Head.link o.tape with
    | Link.End -> assert false
    | Link.Cell Statement.(Declare (_, (Some mark))) ->
       let back = Stage.Back (Energy.unmark mark back) in
       Some { o with tape = o.tape |> Tape.Head.unmark
                                   |> Tape.Head.change_stage back
            }
    | Link.Cell Statement.(Call (_, (Some wait))) ->
       let call = Stage.Call (Energy.return wait back) in
       Some { o with tape = o.tape |> Tape.Head.remove_wait
                                   |> Tape.Head.change_stage call
            }
    | Link.Cell Statement.(Perform _ | Call _ | Declare _) ->
       Some o
    | Link.Start ->
       None
       
  let step o =
    let o = { o with tape = Tape.Head.move o.tape } in
    match Tape.Head.stage o.tape with
    | Stage.Call call -> Some (call_step call o)
    | Stage.Find find -> Some (find_step find o)
    | Stage.Back back -> back_step back o
  end

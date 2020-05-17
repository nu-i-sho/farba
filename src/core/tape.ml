module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end
                     
module Make (Commander : COMMANDER) = struct
  
  module Stage = struct
    type t =
      | Call of Energy.Call.t
      | Back of Energy.Back.t
      | Find of Energy.Find.t
    end

  module PrevStatement = struct
     type t = 
        | Perform of Action.t
        | Call    of Dots.t * Energy.Wait.t option
        | Declare of Dots.t * Energy.Mark.t option
     end
             
  module rec Prev : sig
    include module type of PrevStatement
    val of_next : Next.t -> t
    end = struct
       
    include PrevStatement
    let of_next = function
      | Next.Perform x -> Perform x
      | Next.Call    x -> Call (x, None)
      | Next.Declare x -> Declare (x, None)
    end

  and Next : sig
    include module type of Statement
    val of_statement : Statement.t -> Next.t
    val of_prev : Prev.t -> Next.t
    end = struct
    
    include Statement
    let of_statement (_ as o) = o
    let of_prev = function
      | Prev.Perform  x     -> Perform x
      | Prev.Call    (x, _) -> Call x
      | Prev.Declare (x, _) -> Declare x
    end
                             
  type t =
    {  stage : Stage.t;
        prev : Prev.t list;
        next : Next.t list;
      output : Commander.t;
    }
        
  let make commander src =
    {  stage = Stage.Call Energy.origin;
        prev = [];
        next = List.map Next.of_statement src;
        output = commander;
    }

  let move o =
    { o with
      next = (o.next |> List.tl);
      prev = (o.next |> List.hd
                     |> Prev.of_next) :: o.prev
    }

  let move_back o =
    { o with
      prev = (o.prev |> List.tl);
      next = (o.prev |> List.hd
                     |> Next.of_prev) :: o.next
    }

  let call_step call o =
    match o.next with
    | Next.(Perform action) :: _ ->
       { (move o) with output = Commander.perform action o.output
       }
    | Next.(Call procedure) :: t ->
       let wait, find = Energy.find procedure call in
       { o with stage = Stage.Find find;
                 prev = Prev.(Call (procedure, (Some wait))) :: o.prev;
                 next = t
       }     
    | Next.(Declare _) :: _ ->
       { (move o) with stage = Stage.Back (Energy.back call) }
    | [] -> {  o  with stage = Stage.Back (Energy.back call) }

  let find_step find o =
    match o.next with
    | Next.(Declare procedure) :: t
         when procedure = (Energy.Find.procedure find) ->
       let mark, call = Energy.call find in
       { o with stage = Stage.Call call;
                 prev = Prev.(Declare (procedure, (Some mark))) :: o.prev;
                 next = t
       }     
    | Next.(Perform _ | Call _ | Declare _) :: _ -> move o
    | [] -> { o with stage = Stage.Back (Energy.not_found find) }

  let back_step back o =
    match o.prev with
    | Prev.(Declare (procedure, (Some mark))) :: t ->
       Some { o with stage = Stage.Back (Energy.unmark mark back);  
                      prev = Prev.(Declare (procedure, None)) :: t
            }
    | Prev.(Call (procedure, (Some wait))) :: t ->
       Some { o with stage = Stage.Call (Energy.return wait back);
                      prev = Prev.(Call (procedure, None)) :: t
            }
    | Prev.(Perform _ | Call _ | Declare _) :: _ ->
       Some (move_back o)
    | [] ->
       None
       
  let step o =
    match o.stage with
    | Call call -> Some (call_step call o)
    | Find find -> Some (find_step find o)
    | Back back -> back_step back o

  end

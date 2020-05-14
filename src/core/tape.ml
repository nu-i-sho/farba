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

  module Prev = struct
    type t = 
      | Perform of Action.t
      | Call    of Dots.t * Energy.Wait.t option
      | Declare of Dots.t * Energy.Mark.t option

    let of_statement = function
      | Statement.Perform x -> Perform x
      | Statement.Call    x -> Call (x, None)
      | Statement.Declare x -> Declare (x, None)
    end

  module Statement = struct
    include Statement
    let of_prev = function
      | Prev.Perform x      -> Perform x
      | Prev.Call (x, _)    -> Call x
      | Prev.Declare (x, _) -> Declare x
    end
                             
  type t =
    {   stage : Stage.t;
         prev : Prev.t list;
      current : Statement.t;
         next : Statement.t list;
       output : Commander.t;
    }
            
  let make commander src =
    {  energy = Stage.Call Energy.origin;
         prev = [];
      current = List.hd src;
         next = List.tl src;
       output = commander;
    }

  let call_step call o =
    match o.current, o.next with
    | ((Statement.Perform action) as p), (c :: n) ->
       { o with  prev = p :: o.prev;
              current = c;
                 next = n;
               output = Commander.perform action o.output;
       }
    | (Statement.Perform action), [] ->
       { o with stage = Stage.Back (Energy.back call)
               output = Commander.perform action o.output;     
       }
    | (Statement.Call procedure), (c :: n) ->
       let wait, find = Energy.find procedure call in
       { o with stage = Stage.Find find;
                 prev = (Prev.Call (procedure, (Some wait))) :: o.prev;
              current = c;
                 next = n
       }
    | (Statement.Call procedure), [] ->
       { o with stage = Stage.Back (Energy.back call)
       }
    | (Statement.Declare procedure), _ ->
       { o with stage = Stage.Back (Energy.back call);
                 prev = (Prev.Declare (procedure, None)) :: o.prev
       }

  let find_step find o =
    match o.current, o.next with
    | (Statement.Declare procedure), (c :: n)
         when procedure = (Energy.Find.procedure find) ->
       let mark, call = Energy.call find in
       { o with stage = Stage.Call call;
                 prev = (Prev.Declare (procedure, (Some mark))) :: o.prev;
              current = c;
                 next = n
       }     
    | (( Statement.Perform _
       | Statement.Call    _
       | Statement.Declare _
       ) as p), (c :: n) ->
       { o with  prev = (Prev.of_statement p) :: o.prev;
              current = c;
                 next = n;
       }
    | (( Statement.Perform _
       | Statement.Call    _
       | Statement.Declare _
       ) as p), [] ->
       { o with stage = Stage.Back (Energy.not_found find)
       }


  let back_step back o =
    match o.current, o.prev with
    | (Statement.Declare (procedure, (Some mark)), (c :: p) ->
       { o with stage = Stage.Back (Energy.unmark mark back);
                 prev = p;
              current = Statement.of_prev c;
                 next =    
      
       
  let step o =
    match o.stage with
    | Call call -> call_step call o
    | Find find -> find_step find o
    | Back back -> back_step back o
  end

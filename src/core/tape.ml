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

  module rec Prev : sig
    type t = 
      | Perform of Action.t
      | Call    of Dots.t * Energy.Wait.t option
      | Declare of Dots.t * Energy.Mark.t option
    end = Prev
  and Next : module type of Statement = Next 
           
  module Prev = struct
    include Prev
    let of_next = function
      | Next.Perform x -> Perform x
      | Next.Call    x -> Call (x, None)
      | Next.Declare x -> Declare (x, None)
    end

  module Next = struct
    include Next
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
        next = src;
      output = commander;
    }

  let move o =
    let prev =
      o.next |> List.hd
             |> Prev.of_next
    and next =
      o.next |> List.tl in
    { o with
      prev;
      next 
    }
    
  let call_step call o =
    match o.next with
    | Next.(Perform action) :: _ :: _ ->
       { (move o) with
         output = Commander.perform action o.output
       }
    | Next.(Perform action) :: [] ->
       { o with
          stage = Stage.Back (Energy.back call);
         output = Commander.perform action o.output    
       }
    | Next.(Call procedure) :: ((_ :: _) as t) ->
       let wait, find = Energy.find procedure call in
       { o with
          stage = Stage.Find find;
           prev = Prev.(Call (procedure, (Some wait))) :: o.prev;
           next = t
       }
    | Next.((Call _) :: [] | (Declare _) :: _) ->
       { o with
          stage = Stage.Back (Energy.back call)
       }

  let find_step find o =
    match o.next with
    | Next.(Declare procedure) :: ((_ :: _) as t)
         when procedure = (Energy.Find.procedure find) ->
       let mark, call = Energy.call find in
       { o with
          stage = Stage.Call call;
           prev = Prev.(Declare (procedure, (Some mark))) :: o.prev;
           next = t
       }     
    | Next.(Perform _ | Call _ | Declare _) :: _ :: _  -> move o
    | Next.(Perform _ | Call _ | Declare _) :: []      -> 
       { o with
          stage = Stage.Back (Energy.not_found find)
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

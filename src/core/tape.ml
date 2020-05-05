module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end

exception Impossible 
                      
module Make (Commander : COMMANDER) = struct
  module Param = struct
    type t =
      {   name : Dots.t;
        values : Dots.t Command.t list
      }

    let empty name =
      { values = [];
          name  
      }
    end
        
  type ('statement, 'energy) e =
    { statement : 'statement;
         energy : 'energy
    }
  
  module Prev = struct
    module Energy = struct
     type t  =
       | Mark of Energy.Mark.t 
       | Wait of Energy.Wait.t
       | None
      end

    type t = ((Param.t, Loop.t) Statement.t, Energy.t) e
    end

  module Next = struct
    type t = (Param.t, Dots.t) Statement.t
 
    let of_src x =
      Statement.( Command.(
        let command =
          match x.command with
          | (Perform _ | Call _ | Procedure _)
              as command  -> command
          | (Parameter p) -> Parameter (Param.empty p) in
        { x with command
        }
      ))
    end

  module Current = struct
    module Energy = struct
      type t =
        | Call of Energy.Call.t
        | Back of Energy.Back.t
        | Find of Energy.Find.t

      let origin =
        Call Energy.origin
      end

    type t = ((Param.t, Loop.t) Statement.t option, Energy.t) e

    let origin =
      { statement = None;
           energy = Energy.origin
      }
    end

  type t =
    { commander : Commander.t;
           prev : Prev.t list;
        current : Current.t;
           next : Next.t list
    }

  let make commander src =
    { commander;
         prev = [];
      current = Current.origin;
         next = List.map Next.of_src src
    }

  let step o =
    let module Av = Availability in
    let open Statement in
    let open Param in
    match o with
    (* 1 *)
    | { current =
          {    energy = Current.Energy.Call _;
            statement =
              Some ({    loop = Some (Av.Enabled ((Loop.Active _) as loop));
                      command = ( Command.Perform action
                                | Command.Parameter
                                    { values = (Command.Perform action) :: _; _
                                    });
                      _
                    } as statement)
          };
        _
      } -> let commander = Commander.perform action o.commander 
           and loop      = Some (Av.Enabled (Loop.iter loop)) in
           let statement = Some { statement with loop } in
           let current   = { o.current with statement } in
           { o with
             commander;
             current
           }      
    (* 2 *)
    | { current = ({  energy = Current.Energy.Call _; _ });
           next = ({ command = ( Command.Perform action
                               | Command.Parameter
                                   { values = (Command.Perform action) :: _; _
                               });
                     _
                   } as next_statement) :: next;
           _ 
      } -> let commander = Commander.perform action o.commander
           and loop =
             match next_statement.loop with
             | None                 -> None
             | Some (Av.Disabled _) -> raise Impossible
             | Some (Av.Enabled  x) ->
                let x = Loop.make x in
                let x = Loop.iter x in
                Some (Av.Enabled x) in
      
           let statement = Some { next_statement with loop } in
           let current = { o.current with statement }
           and prev = 
             match o.current.statement with
             | None   -> o.prev 
             | Some x -> { statement = x;
                              energy = Prev.Energy.None
                         } :: o.prev in
           { commander;
             prev;
             current;
             next
           }
           
    (* 4 *) 
    | { current = ({    energy = Current.Energy.Call e;
                     statement = Some current_statement });
           next = ({   command = ( Command.Procedure _
                                 | Command.Parameter { values = []; _ });
                     _
                   } as next_statement) :: next_tail;
           _
      } -> { o with prev = {    energy = Prev.Energy.None;
                             statement = current_statement
                           } :: o.prev;
                 current = {    energy = Current.Energy.Back (Energy.back e);
                             statement = Some next_statement;
                           };
                    next = next_tail
           }
    (* 5 *) 
    | { current = ({    energy = Current.Energy.Call e;
                     statement = None });
           next = ({   command = ( Command.Procedure _
                                 | Command.Parameter { values = []; _ });
                     _
                   } as next_statement) :: next_tail;
           _
      } -> { o with prev = o.prev;
                 current = {    energy = Current.Energy.Back (Energy.back e);
                             statement = Some next_statement;
                           };
                    next = next_tail
           }

    | { current = ({  energy = Current.Energy.Call e; _ });
           next = ({ command = ( Command.Procedure _
                               | Command.Parameter { values = []; _ });
                        loop = next_loop;
                     _
                   } as next_statement) :: next_tail;
           _
      } -> let current_loop = 
           { o with prev = o.prev;
                 current = {    energy = Current.Energy.Back (Energy.back e);
                             statement = Some next_statement;
                           };
                    next = next_tail
           }
                     
  end

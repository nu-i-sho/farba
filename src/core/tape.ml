module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end
  
module Make (Commander : COMMANDER) = struct
  module Param = struct
    type t =
      {   name : Dots.t;
        values : Dots.t Command.t List.t
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

    type t = ((Param.t, Loop.t) Statement.t Option.t, Energy.t) e

    let origin =
      { statement = None;
           energy = Energy.origin
      }
    end

  type t =
    { commander : Commander.t;
           prev : Prev.t List.t;
        current : Current.t;
           next : Next.t List.t
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
    | { current =
          {    energy = Current.Energy.Call _;
            statement =
              Some ({    loop = Some (Av.Enabled ((Loop.Active _) as loop));
                      command = ( Command.Perform action
                                | Command.Parameter
                                    { values = (Command.Perform action) :: _;
                                      _
                                    }
                                );
                      _
                    } as statement)
          } as current;
        _
      } -> { o with
             commander = Commander.perform action o.commander;
               current =
                 { current with
                   statement =
                     Some { statement with
                            loop = Some (Av.Enabled (Loop.iter loop))
                          }
                 }
           }
  end

module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end
  
module Make (Commander : COMMANDER) = struct
  module Param = struct
    type t =
      {   name : Dots.t;
        values : Dots.t Command.t Dots.Map.t
      }

    let empty name =
      { values = Dots.Map.empty;
        name;  
      }
    end

  module Loop = struct
    type t =
      { count : Dots.t;
         iter : Dots.t
      }
      
    let make count =
      { count;
        iter = count
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

    type nonrec e = ((Param.t, Loop.t) Statement.t, Energy.t) e
    type t = e List.t
    end

  module Next = struct
    type nonrec e = (Param.t, Dots.t) Statement.t
    type t = e List.t
           
    let of_src =
      let convert src =
        Statement.( Command.(
          let command =
            match src.command with
            | (Do _ | Call _ | Procedure _)
               as command   -> command
            | (Parameter x) -> Parameter (Param.empty x) in
          { src with command
          }
        )) in
      List.map convert
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

    let of_next x =
      let loop = match Statement.(x.loop) with
                 | Some l -> Some (Loop.make l)
                 | None   -> None in
      let x = Statement.{ x with loop } in
      { statement = Some x;
           energy = Energy.origin
      }
    end

  type t =
    { commander : Commander.t;
           prev : Prev.t;
        current : Current.t;
           next : Next.t
    }

  let make commander src =
    let next    = Next.of_src src in 
    let current = Current.of_next (List.hd next) in
    let next    = List.tl next in
    { commander;
      prev = [];
      current;
      next
    }
    
  end

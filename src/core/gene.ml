module OfFlesh = struct
  type t = | Kind of Kind.t
           | State of State.t
end

module OfSpirit = struct
  type t = Dots.t
end

module OfProgramm = struct
  
  module ForAct = struct

    module ForTurn = struct
      type t = | Left
               | Right 
    end

    module ForReplicate = struct
      type t = | Direct
               | Inverse
    end

    type t = | Turn of ForTurn.t
             | Replicate of ForReplicate.t 
  end

  module ForCall = struct
    type t = Crosses.t * Dots.t
  end

  module ForDeclare = struct
    type t = Crosses.t * Dots.t
  end

  type t = | Act of ForAct.t
           | Call of ForCall.t
           | Declare of ForDeclare.t
end

type t = | Code of OfProgramm.t
         | Spirit of OfSpirit.t

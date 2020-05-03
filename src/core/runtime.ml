module Statement = struct
  module Param = struct
    type t =
      {   name : Dots.t;
        values : Dots.t Command.t Dots.Map.t
      }
    end

  module Loop = struct
    type t =
      { count : Dots.t;
         iter : Dots.t
      }    
    end

  type t = (Param.t, Loop.t) Statement.t
  end

module Base = struct
  module Declaration = struct
    type 'parameter t =
      | Procedure of Dots.t
      | Parameter of 'parameter
    end

  module Action = struct
    type 'call t =
      | Command of Command.t
      | Call of 'call
    end
                     
  type ('action, 'parameter) t =
    | Declare of 'parameter Declaration.t
    | Do of 'action
  end

module ForArgument = struct
  type t = (Dots.t Base.Action.t, Dots.t) Base.t (*
  type t = | Declare of | Procedure of Dots.t
                        | Parameter of Dots.t
           | Do of | Command of Command.t
                   | Call of Dots.t   
*)end

module OfSourceCode = struct
  module Call = struct
    type t =
      { procedure : Dots.t;
        arguments : ForArgument.t Dots.Map.t
      }
    end

  module Action = struct
    type t =
      { value : Call.t Base.Action.t;
        count : Dots.t
      }
    end
                
  type t = (Action.t, Dots.t) Base.t (*
  type t = | Declare of | Procedure of Dots.t
                        | Parameter of Dots.t
           | Do of { count : Dots.t;
                     value : | Command of Command.t
                             | Call of { procedure : Dots.t;
                                         arguments : ForArgument.t Dots.Map.t 
                                       }
                   }
*)end

module InRuntime = struct
  module Action = struct
    module Loop = struct
      type t =
        { count : Dots.t;
           iter : Dots.t
        }
      end
    
    type t =
      { value : OfSourceCode.Call.t Base.Action.t;
         loop : Loop.t
      }
    end

  module Parameter = struct
    type t =
      {   name : Dots.t;
        values : ForArgument.t List.t
      }
    end
                
  type t = (Action.t, Parameter.t) Base.t (*
  type t = | Declare of | Procedure of Dots.t
                        | Parameter of {   name : Dots.t
                                         values : ForArgument.t List.t
                                       }
           | Do of {  loop : { count : Dots.t;
                                iter : Dots.t
                             };
                     value : | Command of Command.t
                             | Call of { procedure : Dots.t;
                                         arguments : ForArgument.t Dots.Map.t 
                                       }
                    }
*)end

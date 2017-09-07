open Common

type mode =
  | Call
  | Find
  | Back
  | Stay
  
type energy =
  { generation : Dots.t;
          mode : mode
  }

type arg = command
type args =
  { items : arg Dots.Map.t;
       id : int
  }

type stash =
  { value : command;
    owner : int
  }
  
type loop =
  | Wait of Dots.t
  | Work of {  origin : Dots.t;
              current : Dots.t
            }

type any =
  | Energy of energy
  | Arg of arg
  | Loop of loop
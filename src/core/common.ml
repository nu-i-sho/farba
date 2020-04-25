type pigment =
  | White
  | Blue
  | Gray

type side =
  | Up
  | LeftUp
  | RightUp
  | Down
  | LeftDown
  | RightDown

type nucleus =
  { pigment : pigment;
       gaze : side
  }

type hand    =     Left | Right
type nature  =     Body | Mind
type gene    = Dominant | Recessive
type command =
  | Turn of hand
  | Move of nature
  | Replicate of gene
             
type declaration =
  | Procedure
  | Parameter

type statement =
  | Do of command
  | Call of procedure
  | Declare of declaration

 and procedure =
  { name : Dots.t;
    args : statement DotsMap.t;
    loop : Dots.t option
  }

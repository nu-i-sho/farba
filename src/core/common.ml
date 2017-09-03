type pigment =
  | White
  | Blue
  | Gray

type hand =
  | Left
  | Right

type side =
  | Up
  | LeftUp
  | RightUp
  | Down
  | LeftDown
  | RightDown

type relation =
  | Direct
  | Inverse

type nuture =
  | Matter
  | Spirit
  
type action =
  | Replicate of relation
  | Turn of hand
  | Move of nuture
  
type command =
  | Act of action
  | Call of Dots.t
  | Declare of Dots.t
  | Param of Dots.t
  | Nope
  | End

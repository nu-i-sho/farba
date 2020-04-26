type hand    =     Left | Right
type nature  =     Body | Mind
type gene    = Dominant | Recessive
type command =
  | Turn of hand
  | Move of nature
  | Replicate of gene
             
type declaration =
  | Procedure of Dots.t
  | Parameter of Dots.t

type statement =
  | Do of command
  | Call of procedure
  | Declare of declaration

 and procedure =
  { name : Dots.t;
    args : statement Dots.Map.t;
    loop : Dots.t option
  }

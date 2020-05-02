module type STAGE = sig
  type t
  val value : t -> Dots.t
  end

module type DIE = sig
  include STAGE
  val make : Dots.t -> t
  end
                  
module Die : DIE = struct
  type t = Dots.t
  let make value = value
  let value o = o
  end

module Mark : DIE = struct include Die end
module Call : DIE = struct include Die end
module Wait : DIE = struct include Die end
module Back : DIE = struct include Die end
                    
module Find : sig include STAGE
                  val make : Dots.t -> Dots.t -> t
                  val procedure : t -> Dots.t
              end = struct

  type t = Dots.t * Dots.t
  let make procedure value =
    value, procedure
    
  let value = fst 
  let procedure = snd
  end

type t = | Mark of Mark.t
         | Call of Call.t
         | Wait of Wait.t
         | Back of Back.t
         | Find of Find.t
         | None
                  
let origin =
  Call.make Dots.min

let find procedure call =
  (call |> Call.value
        |> Wait.make),
  (call |> Call.value
        |> Dots.succ
        |> Find.make procedure)

let call find =
  (find |> Find.value
        |> Mark.make),
  (find |> Find.value
        |> Call.make)
  
let back call =
  (call |> Call.value
        |> Back.make)
    
let unmark mark back = back
let return wait back =
  (wait |> Wait.value
        |> Call.make)

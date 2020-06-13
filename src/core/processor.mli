type t
   
val make : Tissue.t -> Tape.t -> t
val step : t -> t option

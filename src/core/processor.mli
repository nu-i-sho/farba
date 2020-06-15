type t
   
include IO.S with type t := t

val make : Tissue.t -> Source.t -> t
val step : t -> t option

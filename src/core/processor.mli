type t

val make : Tissue.t -> Source.t -> t 
val step : t -> t option

type input  := unit -> char
type stream := char Seq.t
type output := stream * (stream -> char * stream)
type t

val load    : input -> t    
val restore : input -> t
val save    : t -> output

type t

val kind_of    : t -> Gene.OfFlesh.Kind.t
val spirit_of  : t -> RNA.t option
val program_of : t -> Gene.OfFlesh.Command.t array
val cytoplazm  : Pigment.t -> t
val turn       : HandSide.t -> t -> t

val replicate  : Relationship.t 
              -> donor:t 
              -> acceptor:t option 
              -> t

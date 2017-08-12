type t
type out_t = | Cell of t
             | Clot
	     | Out

val turn : Side.t -> t -> t
val move : t -> out_t
val replicate : Data.Relation.t -> t -> out_t
val make :  colony : Colony.t
        ->   index : (int * int)
        -> nucleus : Nucleus.t
	-> out_t

type t

val make : Hexagon.t -> t
val radius : t -> int
val eye_radius : t -> int
val eyes_coords : Index.t -> Side.t -> t -> (int * int)
val cancer_eyes_coords : Index.t 
                      -> Side.t
                      -> t 
                      -> ((int * int) * (int * int))

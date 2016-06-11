type t

val make              : int -> t
val side              : t -> int
val internal_radius   : t -> int
val external_radius   : t -> int
val internal_radius_f : t -> float
val external_radius_f : t -> float
val center_coord      : Index.t -> t -> (int * int)
val center_coord_f    : Index.t -> t -> (float * float)
val angles_coords     : Index.t -> t -> (int * int) array

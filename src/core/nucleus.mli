type t = private
         { pigment : Pigment.t;
           gaze : Side.t
         }

val make       : Pigment.t -> Side.t -> t
val is_bastard : t -> bool
val turn_left  : t -> t
val turn_right : t -> t
val turn       : Hand.t -> t -> t
val look_back  : t -> t
val inject     : Pigment.t -> t -> t
val replicate  : Gene.t -> t -> t

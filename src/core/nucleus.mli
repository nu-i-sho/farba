type t = private
         { pigment : Pigment.t;
           gaze : Side.t
         }

val make      : Pigment.t -> Side.t -> t
val is_cancer : t -> bool
val turn      : Hand.t -> t -> t
val inject    : Pigment.t -> t -> t
val replicate : Gene.t -> t -> t

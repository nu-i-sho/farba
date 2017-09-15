open Common
type t = nucleus

val make      : Pigment.t -> Side.t -> t
val of_chars  : char -> char -> t
val pigment   : t -> Pigment.t
val gaze      : t -> Side.t
val is_cancer : t -> bool
val turn      : hand -> t -> t
val inject    : Pigment.t -> t -> t
val replicate : relation -> t -> t

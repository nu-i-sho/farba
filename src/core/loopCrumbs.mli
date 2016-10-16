open Data.Shared

type e = | Active of dots * dots
         | Static of dots
type t

val item       : int -> t -> e
val maybe_item : int -> t -> e option
val parse      : string -> t

module Item : sig
    val iter : int -> t -> t
  end

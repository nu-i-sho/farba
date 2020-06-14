module Element : sig
  type t = (Command.t, Dots.t, Dots.t) Statement.t
  include IO.S with type t := t
  end

type t = Element.t list

val empty  : t
include IO.S with type t := t

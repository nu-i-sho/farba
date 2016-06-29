module Decorate (Base : COLONY.T) : sig
    include COLONY.T
    val decorate : Base.t -> t
  end

module Decorate (Colony : COLONY.T) : sig
    include COLONY.T
    val decorate : base:Colony.t -> t
  end

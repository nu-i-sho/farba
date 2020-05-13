module Dots : sig
  type t = | OOOOOO
           | OOOOO
           | OOOO
           | OOO
           | OO
           | O

  include Utils.SEQUENTIAL.T with type t := t
  include Map.OrderedType with type t := t 

  module Map    : Utils.MAPEXT.T with type key = t
  module MapOpt : Utils.MAPEXT.T with type key = t option
      
  val count : int
  val max : t
  val min : t
  val all : t list

  end

type t = | White
         | Blue
         | Gray

include Sig.INVERSABLE with type t := t

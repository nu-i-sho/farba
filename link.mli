module Make (Key : ORDERED.T) (Value : EMPTIBLE.T) = sig
  include EMPTIBLE.T 
	
  val make_with : Value.t -> t
  val value_of  : t -> Value.t
  val go_from   : t -> ~by:Key.t -> t
  val link      : t -> ~to':t -> ~by:Key.t -> t
end

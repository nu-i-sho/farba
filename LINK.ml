module type T = sig
  include MAKEABLE_READONLY_LINK.T
  val link : 'a t -> to':('a t) -> by:key_t -> 'a t
end

module type EXT_T = sig
  type 'b linksMap_t
  type 'a t = { links : 'a t linksMap_t;
		value : 'a
	      }

  include T with type 'a t := 'a t
end

module type MAKE_EXT_T = functor
    (Key : ORDERABLE.T) -> functor
      (Links : Map.S with type key = Key.t) -> 
	EXT_T with type key_t = Key.t 
               and type 'b linksMap_t = 'b Links.t

module type MAKE_T = functor 
    (Key : ORDERABLE.T) -> 
      T with type key_t = Key.t

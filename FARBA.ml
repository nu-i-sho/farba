module type T = sig
  type t
  type direction_t
  type 'a board_link_t

  val make_with    : board_link:(Place.t board_link_t) -> t
  val place_of     : t -> Place.t
  val direction_of : t -> direction_t
  val fill_of      : t -> Fill.t 
  val do_with      : t -> command:Command.t -> t
  
end

module type MAKE_T = functor 
    (Direction : DIRECTION.T) -> functor
      (BoardLink : READONLY_LINK.T with type key_t = Direction.t) ->
	T with type direction_t = Direction.t
	       and board_link_t = BoardLink.t

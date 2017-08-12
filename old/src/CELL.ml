module type T = sig
  include module type of CellState
  include EMPTIBLE.T with type t := t
end

module type MAKE_T = 
    functor (Color : T.T) -> 
      T with type color_t = Color.t

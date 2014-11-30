module type T = sig
  include EMPTIBLE.T  
  include FROM_CHAR_MAKEABLE.T with type t := t
end

module type MAKE_T = functor 
    (SubMaker : FROM_CHAR_MAKEABLE.T) ->
      T

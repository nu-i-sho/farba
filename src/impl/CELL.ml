module type T = sig
  include EMPTIBLE_AND_FROM_CHAR_MAKEABLE.T
end

module type MAKE_T = functor 
    (Color : FROM_CHAR_PARSABLE.T) ->
      T

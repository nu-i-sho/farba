module type T = sig
  type t
  include EMPTIBLE.T with type t := t    
  include FROM_CHAR_MAKEABLE.T with type t := t
end

module type MAKE_T = functor 
    (SubMaker : FROM_CHAR_PARSABLE.T) ->
      T

module type T = sig
  type t
  include EMPTIBLE.T with type t := t    
  include FROM_CHAR_PARSABLE.T with type t := t
end

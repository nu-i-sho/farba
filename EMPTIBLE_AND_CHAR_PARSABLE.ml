module type T = sig
  type t
  include EMPTIBLE.T with type t := t    
  include PARSABLE.T with type t := t and source_t = char
end

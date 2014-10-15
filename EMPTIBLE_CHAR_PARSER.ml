module type T = sig
  type t
  include EMPTIBLE.T    with type t := t    
  include CHAR_PARSER.T with type t := t
end

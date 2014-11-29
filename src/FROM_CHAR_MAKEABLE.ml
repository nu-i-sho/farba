module type T = sig
  include MAKEABLE.T with type source_t = char
end

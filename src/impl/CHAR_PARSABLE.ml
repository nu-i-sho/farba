module type T = sig
  include PARSABLE.T with type source_t = char
end

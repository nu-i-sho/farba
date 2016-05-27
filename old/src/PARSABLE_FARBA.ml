module type T = sig
  include FARBA.T
  include PARSABLE.T with type t := t and type source_t = string
end


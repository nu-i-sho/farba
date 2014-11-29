module type T = sig
  type t
  include FARBA.T    with type t := t
  include PARSABLE.T with type t := t and type source_t = string
end


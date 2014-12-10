module type T = sig
  type t
  type source_t
  type product_t
  val convert : source_t -> t -> product_t
  include MAKEABLE.T with type t := t
end

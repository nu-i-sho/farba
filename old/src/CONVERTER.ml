module type T = sig
  type source_t
  type product_t
  val convert : source_t -> product_t
end

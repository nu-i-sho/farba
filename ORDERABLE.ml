module type T = sig
  type 'a t
  val compare : 'a t -> 'a t -> int
end

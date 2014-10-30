module type T = sig
  type 'a t
  
  val send : 'a -> 'a t -> 'a t
end

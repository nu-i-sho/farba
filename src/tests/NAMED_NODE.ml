module type T = sig
  include NAMED.T
  type child_t
  val children : child_t list 
end

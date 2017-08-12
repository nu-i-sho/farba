module type T = sig
  include READONLY_LINK.T
  val make : 'a -> 'a t    
end

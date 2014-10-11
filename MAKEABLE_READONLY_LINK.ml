module type T = sig
  include READONLY_LINK.T
  val make_with : 'a -> 'a t    
end

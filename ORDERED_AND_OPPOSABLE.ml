module type T = sig
  include ORDERED.T
  include OPPOSABLE.T 
end

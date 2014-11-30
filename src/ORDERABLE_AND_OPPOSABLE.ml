module type T = sig
  include ORDERABLE.T
  include OPPOSABLE.T with type t := t 
end

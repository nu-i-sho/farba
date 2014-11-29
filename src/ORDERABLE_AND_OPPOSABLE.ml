module type T = sig
  type t
  include ORDERABLE.T with type t := t
  include OPPOSABLE.T with type t := t 
end

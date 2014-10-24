type t =   
  | Left
  | Right

include ORDERABLE_AND_OPPOSABLE.T with type t := t 

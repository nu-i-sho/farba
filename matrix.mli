module Make : functor (Elt : Iemptible.T) -> 
  (Imatrix.T with type elt := Elt.t)

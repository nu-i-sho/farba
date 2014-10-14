module type T = sig
  type farba_t
  build : level:Level.t -> farba_t
end

module type MAKE_T = functor 
    (Farba : FARBA.T) -> 
      T with type farba_t = Farba.t 

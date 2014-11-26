module Make : DUMMY_MAKEABLE.MAKE_T = functor 
  (Product : T.T) -> functor
    (Source : T.T) -> struct
      type t = Product.t
      type source_t = Source.t
      
      let storage = ref []

      let set_make (source, product) = 
	storage := (source, product) :: storage 

      let make source = 
	List.assoc !storage source
    end

module type T = sig

    include MATRIX.T with type e = Nucleus.t option
    val set  : (int * int) -> e -> t -> t
    val load :  width : int 
	    -> height : int 
            -> source : SourceFor.Founa.t -> t 
            -> t
  end

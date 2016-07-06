module type T = sig
    type e
    type t

    val height : t -> int
    val width  : t -> int
    val get    : (int * int) -> t -> e
   
  end

module SizeOf (Matrix : READ_T) = struct
    let height = Matrix.height
    let width = Matrix.width
  end

let map (type a) (type b) f 
	(module Matrix : T with type e = a) =
      
  (module struct
     type e = b
     include SizeOf (Matrix)
		    
     let get i o = f (Matrix.get i o)
   end : T)

let mapi (type a) (type b) f 
	 (module Matrix : T with type e = a) =

  (module struct
     type e = b
     type t = Matrix.t
     include SizeOf (Matrix)
		    
     let get i o = f i (Matrix.get i o)
   end : T)

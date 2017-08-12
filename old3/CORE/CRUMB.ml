module type T = sig
    type t
     
    val first : t  
    val increment : t -> t
    val decrement : t -> t
  end

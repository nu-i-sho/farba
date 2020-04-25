module type T = sig
    include Map.S    
        
    val set         : key -> 'a -> 'a t -> 'a t
    val of_bindings : (key * 'a) list -> ('a t)
  end 

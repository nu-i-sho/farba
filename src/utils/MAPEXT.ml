module type T = sig
    include Map.S    
        
    val set         : key -> 'a -> 'a t -> 'a t
    val of_bindings : (key * 'a) list -> ('a t)
      
    (* TODO: remove it after 
             update OCaml to 4.05 *)
    val find_opt    : key -> 'a t -> 'a option
  end 

module type MAKE_T = functor 
    (Base : LINK.T) = functor 
    (Extention : LINK_PLUS.T) = struct
      type 'a t
      type key_t
      include Base      with type 'a t := 'a t and key_t = key_t
      include Extention with type 'a t := 'a t and key_t = key_t
    end

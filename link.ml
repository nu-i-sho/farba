module Make (Key : ORDERED.T) (Value : EMPTIBLE.T) = struct
  
  module Links = Map.Make(Key)
	
  type t = { links : t Links.t;
	     value : Value.t
	   }

  let empty = 
    { links = Links.empty;
      value = Value.empty
    }

  let make_with value = 
    { links = Links.empty;
      value
    }

  let value_of link = 
    link.value

  let go_from link ~by:key =
    if   link.links |> Links.mem  key 
    then link.links |> Links.find key 
    else empty

  let link linker ~to':linkable' ~by:key = 
    { linker with links = Links.add key linkable' linker.links
    }

end

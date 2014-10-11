module Make : LINK.MAKE_T = functor 
  (Key : ORDERED.T) = struct
  
    module Links = Map.Make(Key)
	
    type 'a t = { links : t Links.t;
		  value : 'a
		}

    type key_t = Key.t
	
    let make_with value = 
      { links = Links.empty;
	value
      }

    let go_from link ~by:key = 
      link.links |> LinksMap.find key 

    let link linker ~to':linkable ~by:key = 
      { linker with links = LinksMap.add key linkable linker.links
      }	

    let is_impasse link ~by:key =
      link.links |> LinksMap.mem key	
  end

module Make(Dir : Idir.T)(Value : Iemptible.T) = struct
  
  module LinksMap = Map.Make(Dir)
	
  type t = { links : t LinksMap.t;
	     value : Value.t
	   }

  let empty = 
    { links = LinksMap.empty;
      value = Value.empty
    }

  let make_with value = 
    { links = LinksMap.empty;
      value
    }

  let value_of link = 
    link.value

  let go_to direction ~from:link =    
    if   LinksMap.mem  direction link.links
    then LinksMap.find direction link.links
    else empty

  let join link and_link ~by:direction = 
    
    let rec new_link =
      { link with links = LinksMap.add 
	  direction
	  new_and_link
	  link.links
      }

    and new_and_link =
      { and_link with links = LinksMap.add
	 (direction |> Dir.mirror)
	  new_link
	  and_link.links
      } 
    in
    new_link

end

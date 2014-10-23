module Make : LINK.MAKE_T = functor 
  (Key : ORDERABLE.T) -> struct
  
    module Links = Map.Make (Key)
	
    type 'a t = { links : t Links.t;
		  value : 'a
		}

    type key_t = Key.t
	
    let make_with value = 
      { links = Links.empty;
	value
      }

    let get_from link ~by:key = 
      link.links |> LinksMap.find key 

    let link linker ~to':linkable ~by:key = 
      { linker with links = LinksMap.add key linkable linker.links
      }	

    let is_impasse link ~by:key =
      link.links |> LinksMap.mem key	

    let rec go_from link ~by:key ~steps_count:i =
      if i = 0 then link else 
        go_from (get_from link ~by:key) 
	  ~steps_count:(i - 1) 
	  ~by:key

    let rec go_to_end_from link ~by:key =
      if is_impasse link ~by:key then link 
      else 
	go_to_end_from 
	  (get_from link ~by:key) 
	  ~by:key

    let len_to_end_of link ~by:key =
      let rec calc link ~counter:i =
	if is_impasse link ~by:key then i else
	  calc (get_from link ~by:key)
	    ~counter:(i + 1) in
      calculate link ~counter:0
  end

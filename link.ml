module MakeForExtend : LINK.MAKE_EXT_T = functor 
  (Key : ORDERABLE.T) -> functor
    (Links : Map.S with type key = Key.t) -> struct
      
      type key_t = Key.t
      type 'b linksMap_t = 'b Links.t
      type 'a t = { links : 'a t linksMap_t;
		    value : 'a
		  }
	
      let make value = 
	{ links = Links.empty;
	  value
	}

      let value_of link = 
	link.value

      let get_from link ~by:key = 
	link.links |> Links.find key 

      let link linker ~to':linkable ~by:key = 
	{ linker with links = Links.add key linkable linker.links
	}	

      let is_impasse link ~by:key =
	link.links |> Links.mem key	

      let rec go_from link ~by:key ~steps_count:i =
	if i = 0 then link else 
          go_from (get_from link ~by:key) 
	    ~steps_count:(i - 1) 
	    ~by:key

      let rec go_to_end_from link ~by:key =
	if is_impasse link ~by:key then link else 
	  go_to_end_from 
	    (get_from link ~by:key) 
	    ~by:key

      let len_to_end_of link ~by:key =
	let rec calc link ~counter:i =
	  if is_impasse link ~by:key then i else
	    calc (get_from link ~by:key)
	      ~counter:(i + 1) in
	calc link ~counter:0
    end

module Make : LINK.MAKE_T = functor 
  (Key : ORDERABLE.T) -> struct
    include MakeForExtend (Key) (Map.Make (Key))
end

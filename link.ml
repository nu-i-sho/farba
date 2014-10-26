module MakeForExtend : LINK.MAKE_EXT_T = functor 
  (Key : ORDERABLE.T) -> struct
      
    type key_t = Key.t
    type 'a t = 
	{ links : (key_t * 'a t) list;
	  value : 'a
	}
	
    let make value = 
      { links = [];
	value 
      }

    let value_of link = 
      link.value

    let get_from link ~by:key = 
      link.links |> List.assoc key 

    let link linker ~to':linkable ~by:key = 
      { linker with links = (key, linkable) :: linker.links
      }	

    let is_impasse link ~by:key =
      link.links |> List.mem_assoc key	

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

    let find_link_in link ~with_value:x ~by:key =
      let rec find_in current =
	if x = value_of current then current else
	  find_in (get_from current ~by:key) in 
      find_in link

    let find_index_of_link_with ~value ~in':link ~by:key = 
      let rec find current acc =
	if value = value_of current then acc else
	  find (get_from current ~by:key)
	       (acc + 1) in 
      find link 0
      
    end

module Make : LINK.MAKE_T = MakeForExtend 

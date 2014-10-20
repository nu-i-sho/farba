module Extend = functor 
  (Base : READONLY_LINK.T) = struct
    include Base

    let rec go_from link ~by:direction ~steps_count:i = 
      if i = 0 then link else 
      go_from 
	(get_from link ~by:direction)
      	~by:direction
	~steps_count:(i - 1)

    let rec go_to_end_from link ~by:direction =
      if is_impasse link ~by:direction then link else 
      go_to_end_from 
	(get direction ~of':link) 
	~by:direction
  end

module Observe (Anatomy : ANATOMY.T)
	      (Observer : Shared.ANATOMY_OBSERVER.T) = struct
  
    type t = { observer : Observer.t; 
	           base : Anatomy.t
	     }

    let make ~anatomy:base 
	    ~observer:obs =

      let height = Anatomy.height base
      and width  = Anatomy.width  base
      and get i  = Anatomy.colony_get i base in
      
      let rec set (x, y) obs =
	if y = h then obs else 
	if x = w then obs |> set (0, (y + 1)) 
                 else obs |> Observer.set (x, y) (get (x, y))
		          |> set ((x + 1), y) 
      in

      { observer = set (0, 0) obs; 
	base 
      } 

    let width  o = o.base |> Anatomy.width  
    let height o = o.base |> Anatomy.height
    let mem i  o = o.base |> Anatomy.mem i
    let get i  o = o.base |> Anatomy.get i

    let set i v o = 
      let previous = o.base |> Anatomy.get i
      and anatomy  = o.base |> Anatomy.set i v
      and current  = o.base |> Anatomy.tissue_get i in

      { observer = Observer.reset i o.observer
				  ~previous
                                  ~current;
	    base = anatomy   
      }
  end

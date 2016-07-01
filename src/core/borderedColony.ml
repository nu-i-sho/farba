module Decorate (Colony : COLONY.T) = struct
    
    type t = Colony.t

    let height o = 2 + (Colony.height o)
    let width  o = 2 + (Colony.width  o)

    let get (x, y) o = 
      if y = 0 || y = (height o) - 1 || 
         x = 0 || x = (width  o) - 1 then 
	Data.Pigment.None else
	Colony.get ((x + 1), (y + 1)) o
 
    let iter f o =
      for x = 0 to (width o) do
	for y = 0 to (height o) do
	  f (get (x, y) o)
	done
      done

    let iterxy f o =
      for x = 0 to (width o) do
	for y = 0 to (height o) do
	  f (x, y) (get (x, y) o)
	done
      done

    let foldxy f acc o =
      let h = height o and w = width o in
      let rec fold ((x, y) as i) acc =
	if y = h then acc else
	  if x = w then fold (0, (y + 1)) acc else
	    fold ((x + 1), y) (f acc i (get i o))
      in
      fold (0, 0) acc

    let fold f =
      let f acc _ = f acc in
      foldxy f

    let decorate base = 
      base
  end

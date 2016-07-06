module Extend (Matrix : MATRIX.T) = struct
    include Matrix

    let in_range (x, y) o =
      x >= 0 && x < (width o) &&
      y >= 0 && y < (height o)

    let is_out i o = 
      not (in_range i o)
    
    let fold f acc o =
      let h = height o and w = width o in
      let rec fold ((x, y) as i) acc =
	if y = h then acc else
	  if x = w then fold (0, (y + 1)) acc else
	    fold ((x + 1), y) (f acc (get i o))
      in
      fold (0, 0) acc

    let foldi f acc o =
      let h = height o and w = width o in
      let rec fold ((x, y) as i) acc =
	if y = h then acc else
	  if x = w then fold (0, (y + 1)) acc else
	    fold ((x + 1), y) (f acc i (get i o))
      in
      fold (0, 0) acc

    let iter f o =
      for x = 0 to (width o) do
	for y = 0 to (height o) do
	  f (get (x, y) o)
	done
      done

    let iteri f o =
      for x = 0 to (width o) do
	for y = 0 to (height o) do
	  let i = x, y in f i (get i o)
	done
      done

    let extend base = base

  end

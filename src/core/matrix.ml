type 'a t = { get_base : (int * int) -> 'a;
              ovveride : 'a Index.Map.t;
                height : int;
                 width : int
	    }

let of_map height width default src =
  let get_default _ = default in
  { get_base = get_default;
    ovveride = src;
      height;
       width
  }

let empty height width default =
  of_map height width default Index.Map.empty 

let of_array src = 
  let from_array (x, y) = src.(y).(x) in
  { get_base = from_array;
    ovveride = Index.Map.empty;
      height = Array.length src;
       width = Array.length src.(0)
  }

let pair a b = 
  a, b

let of_str_list src =

  let add (i, v) = IntMap.add i v in 
  let src = src |> List.mapi pair
                |> List.fold_left add IntMap.empty 
  in

  let get_char (x, y) = (IntMap.find y src).[x]
  and height = IntMap.cardinal src 
  and width  = src |> IntMap.choose
                   |> String.length in

  { get_base = get_char;
    ovveride = Index.Map.empty;
      height;
       width;
  }

let of_str_arr src = 
  let get_char (x, y) = src.(y).[x] in
  { get_base = get_char;
    ovveride = Index.Map.empty;
      height = Array.length src;
       width = String.length src.[o]
  }

let height o = Base.height o.base
let width  o = Base.width  o.base

let set i v o = 
  { o with ovveride = 
	     match (v = o.get_base i), 
		   (Index.Map.mem i o.ovveride) with

	     | false, false -> o.ovveride |> Index.Map.add i v
	     | false, true  -> o.ovveride |> Index.Map.set i v
	     | true,  false -> o.ovveride
	     | true,  true  -> o.ovveride |> Index.Map.remove i
  }
    
let get i o = 
  if Index.Map.mem i o.ovveride then
    Index.Map.find i o.ovveride else
    get_base i

let in_range (x, y) o =
  x >= 0 && x < (width o) &&
  y >= 0 && y < (height o)

let is_out i o = 
  not (in_range i o)

let map f o =  
 let mapped i = f (get i o) in
  { get_base = mapped;
    ovveride = Map.empty;
      height = height a;
       width = width a
  }

let mapi f o =  
 let mapped i = f i (get i o) in
  { get_base = mapped;
    ovveride = Index.Map.empty;
      height = height a;
       width = width a
  }

let map2 f a b = 
  let mapped i = f (get i a) (get i b) in
  { get_base = mapped;
    ovveride = Index.Map.empty;
      height = height a;
       width = width a
  }

let zip a b =
  map2 pair a b 

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

let index f o = 
  let w = width o and h = height o in
  let find ((x, y) as i) =
    if y = h            then None 
    else if x = w       then find (0, (y + 1)) 
    else if f (get i o) then Some i 
                        else find ((x + 1), y)
  in find (0, 0)

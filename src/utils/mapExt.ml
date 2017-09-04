module Make (Key : Map.OrderedType) = struct
    include Map.Make (Key)

    let set key value o =
      if o |> mem key then
         o |> remove key
           |> add key value else 
         o |> add key value
      
    let item = find
    let maybe_item key o =
      if mem key o then
        Some (item key o) else
        None
  end

module Make (Key : Map.OrderedType) = struct
    include Map.Make (Key)

    let set key value o =
      if o |> mem key then
         o |> remove key
           |> add key value else 
         o |> add key value
          
    let of_bindings list =
      let rec of_bindings acc  =
        function | (k, v) :: t -> of_bindings (set k v acc) t
                 | []          -> acc in
      of_bindings empty list
        
   (* TODO: remove it after 
            update OCaml to 4.05 *)
    let find_opt key o =
      if mem key o then
        Some (find key o) else
        None
  end
    
module MakeOpt (Key : Map.OrderedType) =
  Make (struct type t = Key.t option
               let compare = function
                 | Some x ->
                    ( function | Some y -> Key.compare x y
                               | None   -> 1 )
                 | None   ->
                    ( function | Some _ -> -1
                               | None   -> 0 )
        end)      

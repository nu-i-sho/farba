module Make (Key : Map.OrderedType) = struct
    include Map.Make (Key)

    let set key value o =
      if o |> mem key then
         o |> remove key
           |> add key value else 
         o |> add key value
          
    let of_bindings list =
      list |> List.to_seq
           |> of_seq
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

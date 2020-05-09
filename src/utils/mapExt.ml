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
               let compare a b =
                 match a, b with
                 | Some x, Some y ->  Key.compare x y
                 | Some _, None   ->  1
                 | None  , Some _ -> -1
                 | None  , None   ->  0                    
        end)

module ForInt =
  Make (struct type t = int
               let compare = compare
        end)

module ForIntPoint =
  Make (struct type t = int * int
               let compare a b =
                 match  compare (fst a) (fst b) with
                 | 0 -> compare (snd a) (snd b)
                 | x -> x
        end)

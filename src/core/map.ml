module type S = sig
  include Map.S
        
  val set         : key -> 'a -> 'a t -> 'a t
  val of_bindings : (key * 'a) list -> ('a t)
  end

module type OrderedType =
  Map.OrderedType

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
    
module MakeOpt (Key : OrderedType) =
  Make (struct type t = Key.t option
               let compare a b =
                 match a, b with
                 | Some x, Some y ->  Key.compare x y
                 | Some _, None   ->  1
                 | None  , Some _ -> -1
                 | None  , None   ->  0                    
        end)


module MakePair (Fst : OrderedType) (Snd : OrderedType) =
  Make (struct type t = Fst.t * Snd.t
               let compare a b =
                 match  Fst.compare (fst a) (fst b) with
                 | 0 -> Snd.compare (snd a) (snd b)
                 | x -> x
        end)

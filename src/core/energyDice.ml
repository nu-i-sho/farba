open Utils
   
type t = { dies : (int * (Dots.t ListOne.t)) ListOne.t;
           mode : Die.mode;
         }

exception Out_of_range
       
let origin =
  { dies = (0, (Dots.O, [])), [];
    mode = Die.Stay;
  }
  
let top_mode o = o.mode             
let with_top_mode m o =
  { o with mode = m
  }
               
let top_index o =
  o.dies |> ListOne.head
         |> fst

let top_die o =
  Die.({       mode = o.mode;
         generation = o.dies |> ListOne.head
                             |> snd
                             |> ListOne.head;
       })

let to_stay_die dots =
  Die.({ generation = dots;
               mode = Stay;
       })
  
let top_dies o =
  let (_, (hh, ht)), _ = o.dies in
  Die.({ generation = hh;
               mode = o.mode;
       }) :: (List.map to_stay_die ht)

let dies i o =
  if (top_index o) = i then
    top_dies o else
    if o.dies |> ListOne.mem_assoc i then
       o.dies |> ListOne.assoc i
              |> ListOne.map to_stay_die 
              |> ListOne.to_list  else
      []
     
let die i o =
  if (top_index o) = i then
    top_die o else
    o.dies |> ListOne.assoc i
           |> ListOne.head
           |> to_stay_die
  
let maybe_die i o =
  match dies i o with
  | h :: _ -> Some h
  | []     -> None

let jump length o =
  { o with
    dies =
      if length > 0 then
        match o.dies with

        | (i, (hh, [])), t
          -> ((i + length), (hh, [])), t

        | (i, (hh, (hth :: htt))), t
          -> ((i + length), (hh, [])), ((i, (hth, htt)) :: t)
      else
        let j = (top_index o) + length in
        if j < 0 then
          raise Out_of_range else

          let (_, top), dies = o.dies in
          let top = ListOne.last top in
      
          let rec jump_back top = function
            | []                      -> (j, (Dots.O, [])), []
            | (i, h) :: t when i >= j -> jump_back (ListOne.last h) t
            | dies                    -> (j, (top, [])), dies
          in jump_back top dies
  }

let step = jump 1
let step_back = jump (-1)
              
let back o =
  { o with
    dies =
      match o.dies with
      | (i, (hh, [])), ((j, (thh, tht)) :: tt)
           when (pred i) = j     -> (j, (hh, (thh :: tht))), tt
      | (i, (hh, [])), t         -> ((pred i), (hh, [])), t
      | (i, (hh, hth :: htt)), t -> (i, (hth, htt)), t
  }

let succ { dies = ((i, (hh, ht)), t);
           mode = m;
         } = { dies = (i, ((Dots.succ hh), (hh :: ht))), t;
               mode = m;
             }

let pred o =
  { o with
    dies =
      match o.dies with
      | (_, (_, [])), (th :: tt)   -> th, tt 
      | (i, (hh, (hth :: htt))), t -> (i, (hth, htt)), t
      | (i, (hh, [])), []          -> raise Out_of_range
  }

module type READONLY_LINK = sig
  type 'a t
  type key_t

  val value_of   : 'a t -> 'a
  val go_from    : 'a t -> by:key_t -> 'a t
  val is_impasse : 'a t -> by:key_t -> bool 
end

module type MAKEABLE_READONLY_LINK = sig
  include READONLY_LINK
  
  val make_with : 'a -> 'a t    
end

module type LINK = sig
  include MAKEABLE_READONLY_LINK

  val link : 'a t -> to':('a t) -> by:key_t -> 'a t
end

module type ORDERED = sig
  type 'a t
  val compare : 'a t -> 'a t -> int
end

module type MAKE_LINK = 
    functor (Key : ORDERED) -> 
      LINK with type key_t = Key.t

module MakeLink : MAKE_LINK = 
  functor (Key : ORDERED) = struct
      
    module LinksMap = Map.Make(Key)
	
    type 'a t = { links : 'a t LinksMap.t;
		  value : 'a
		}

    type key_t = Key.t
	
    let make_with value = 
      { links = LinksMap.empty;
	value
      }

    let value_of link = 
      link.value

    let go_from link ~by:key = 
      link.links |> LinksMap.find key 

    let link linker ~to':linkable ~by:key = 
      { linker with links = LinksMap.add key linkable linker.links
      }	

    let is_impasse link ~by:key =
      link.links |> LinksMap.mem key
  end

module type INTEROPPOSITION_LINK = sig
  include MAKEABLE_READONLY_LINK

  val join : t -> with':t -> by:key_t -> t
end

module type OPPOSABLE = sig
  type t
  val opposite : t -> t
end

module type ORDERED_AND_OPPOSABLE = sig
  include ORDERED
  include OPPOSABLE
end

module type MAKE_INTEROPPOSITION_LINK = 
    functor (Key : ORDERED_AND_OPPOSABLE) -> 
      INTEROPPOSITION_LINK with type key_t = Key.t

module MakeInterOppositionLink : MAKE_INTEROPPOSITION_LINK = 
  functor (Key : ORDERED_AND_OPPOSABLE) = struct
    include MakeLink (Key)
	
    let join a ~with':b ~by:key = 
      let rec a' = link a ~to':b' ~by:key
          and b' = link b ~to':a' ~by:(Key.opposite key) in
      a'
  end  

module type DIRECTION = sig
  include ORDERED_AND_OPPOSABLE

  val turn : t -> ~to':Hand.t -> t
end

module type DIRECTION_SEED = sig
  type t
  val all_ordered_to_right : t List.t
end

module type MAKE_DIRECTION = functor
    (Seed : DIRECTION_SEED) -> 
      DIRECTION with type t = Seed.t

module type DLINK = sig
  include INTEROPPOSITION_LINK with type key_t = Hand.t

  val load_from : 'a List.t
end

module Dlink : DLINK = struct
  include MakeInterOppositionLink (Hand)
  open Hand

  let load_from source = 
    let links = List.map make_with source in
    List.fold_left 
      (fun a b -> join a ~with':b ~by:Right)
      List.hd links
      List.tl links
end

module type ROUNDELAY_LINK = sig
  include READONLY_LINK with type key_t = Hand.t

  val close : 'a Dlink.t -> 'a t 
end

module HandSeed : DIRECTION_SEED = struct
  type t = | Left
           | Right

  let all_ordered_to_right = 
    [Left; Right]
end

module SquereDirectionSeed : DIRECTION_SEED = struct 
  type t = | Up
           | Down 
           | Left
           | Right

  let all_ordered_to_right = 
    [Down; Left; Up; Right]
end

module HexagonDirectionSeed : DIRECTION_SEED = struct
  type t = | Up
	   | Rightup
	   | Rightdown
	   | Down
	   | Leftdown
	   | Leftup

  let all_ordered_to_right = 
    [Down; Leftdown; Leftup; Up; Rightup; Rightdown]
end

module Hand : DIRECTION = MakeDirection (HandSeed)
   and MakeDirection : MAKE_DIRECTION = functor
    (Seed : DIRECTION_SEED) = struct
      open Hand

      type t = Seed.t

      let start =
	RoundelayLink.close 
	  (Dlink.load_from 
	     Seed.all_ordered_to_right) 

      let opposite_index = 
	let start_value = Dlink.value_of start in
	let rec count current acc =
          if current = start_value && acc <> 0
	  then acc
	  else count 
	      (Dlink.go_from current ~by:Righ) 
	      (acc + 1) 
	in
	(count start 0) / 2

      let opposite direction =
	let rec opposite' current i  =
	  if i = opposite_index
	  then Dlink.value_of current
	  else opposite' 
	      (Dlink.go_from current ~by:Right)
	      (i + 1)	    
	in
	opposite' start 0 

      let compare x y =
	let index_of direction =
	  let rec index_of' current acc =
	    if direction = Dlink.value_of current
	    then acc 
	    else index_of'
		(Dlink.go_from current ~by:Right)
		(acc + 1) 
	  in 
	  index_of' start 0 in
	Pervasives.compare
	  (index_of x)
	  (index_of y)
	  
      let turn direction ~to':hand = 
	let rec find ~current =
	  if direction = Link.value_of current
	  then current
	  else find (Link.go_from current ~by:Right)
	in
	Link.go_from
	  (find ~current:start)
	  ~by:hand
    end

module SquereDirection : DIRECTION =
  MakeDirection (SquereDirectionSeed)

module HexagonDirection : DIRECTION = 
  MakeDirection (HexagonDirectionSeed)









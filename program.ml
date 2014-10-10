module type T = sig
  type t
end

module type EMPTIBLE = sig
  include T
  val empty : t
end

module type READONLY_LINK = sig
  include EMPTIBLE

  type key_t
  type value_t
  
  val value_of      : t -> value_t
  val go_from       : t -> by:key_t -> t
  val is_impasse_by : key_t -> bool 
end

module type MAKEABLE_READONLY_LINK = sig
  include READONLY_LINK

  val make_with : value_t -> t    
end

module type LINK = sig
  include MAKEABLE_READONLY_LINK

  val link : t -> to':t -> by:key_t -> t
end

module type ORDERED = sig
  include T
  val compare : t -> t -> int
end

module type MAKE_LINK = functor 
    (Key : ORDERED) 
      (Value : EMPTIBLE) -> 
	LINK with type key_t = Key.t and value_t = Value.t

module MakeLink : MAKE_LINK = functor 
  
  (Key : ORDERED) 
    (Value : EMPTIBLE) = struct
      
      module LinksMap = Map.Make(Key)
	
      type t = { links : t LinksMap.t;
		 value : value_t
	       }

      type key_t   = Key.t
      type value_t = Value.t

      let empty = 
	{ links = LinksMap.empty;
	  value = Value.empty
	}
	
      let make_with value = 
	{ links = LinksMap.empty;
	  value
	}

      let value_of link = 
	link.value

      let go_from link by:key =
	if   link.links |> LinksMap.mem  key 
	then link.links |> LinksMap.find key 
	else empty

      let link linker to':linkable by:key = 
	{ linker with links = LinksMap.add key linkable linker.links
	}	
    end

module type INTEROPPOSITION_LINK = sig
  include MAKEABLE_READONLY_LINK

  val join : t -> with':t -> by:key_t -> t
end

module type OPPOSABLE = sig
  include T
  val opposite : t -> t
end

module type ORDERED_AND_OPPOSABLE = sig
  include ORDERED
  include OPPOSABLE
end

module type MAKE_INTEROPPOSITION_LINK = functor 
    (Key : ORDERED_AND_OPPOSABLE)
      (Value : EMPTIBLE) -> 
	INTEROPPOSITION_LINK with type key_t = Key.t and value_t = Value.t

module MakeInterOppositionLink : MAKE_INTEROPPOSITION_LINK = functor
  
  (Key : ORDERED_AND_OPPOSABLE)
    (Value : EMPTIBLE) = struct
      
      include Link.Make (Key) (Value)

      let join a ~with':b ~by:key = 
	let rec a' = link a ~to':b' ~by:key
            and b' = link b ~to':a' ~by:(Key.opposite key) in
	a'
    end  

module Hand = struct
  type t = | Left
           | Right
end

module type DIRECTION = sig
  include ORDERED_AND_OPPOSABLE

  val turn : t -> ~to':Hand.t -> t
end

module type DIRECTION_SEED = sig
  type t
  val link_to_start_of_directions_roundelay
      : RoundelayLink with type value_t = t
end

module type MAKE_DIRECTION = functor
    (Seed : DIRECTION_SEED) -> 
      DIRECTION with type t = Seed.t

module MakeDirection : MAKE_DIRECTION = functor
  (Seed : DIRECTION_SEED) = struct
    open Hand

    module Link = MakeRoundelayLink (Seed)

    type t = Seed.t

    let start = 
      Seed.link_to_start_of_directions_roundelay

    let count = 
      let rec count' current acc =
        if current = (Link.value_of start) && acc <> 0
	then acc
	else count' 
	    (Link.go_from current ~by:Righ) 
	    (acc + 1) 
      in
      count' start 0

    let opposite direction =
      let index_of_opposite_direction = count / 2 in
      let rec opposite' current i  =
	if i = index_of_opposite_direction
	then Link.value_of current
	else opposite' 
	    (Link.go_from current ~by:Right)
	    (i + 1)	    
      in
      opposite' start 0 

    let compare x y =
      let index_of direction =
	let rec index_of' current acc =
	  if direction = Link.value_of current
	  then acc 
	  else index_of'
	      (Link.go_from current ~by:Right)
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

module type DLINK = sig
  include INTEROPPOSITION_LINK with type key_t = Hand.t

  val load_from : value_t List.t
end

module type MAKE_DLINK = functor
    (Value : EMPTIBLE) -> 
      DLINK with type key_t = Hand.t and value_t = Value.t

module MakeDlink : MAKE_DLINK = functor
  (Value : EMPTIBLE) = struct
    include MakeInterOppositionLink (Hand) (Value)
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

  val close : value_t 
end

module type MAKE_ROUNDELAY_LINK = functor
    (Direction : DIRECTION) -> sig
      include READONLY_LINK with type key_t = Hand.t

      val close : MakeDlink (Direction).t -> t
    end 

module type MakeRoundDelayLink : MAKE_ROUNDELAY_LINK = functor
    (Direction : DIRECTION) = struct
      include MakeDlink (Direction)

      let close dlink =
	f
    end





module Make : DLINK.MAKE_T = functor
  (Value : EMPTIBLE.T) = struct
    include Interopposition_link.Make (Hand) (Value)

    let load_from source = 
      let links = List.map make_with source in
      List.fold_left 
	(fun a b -> join a ~with':b ~by:Hand.Right)
	List.hd links
	List.tl links
  end

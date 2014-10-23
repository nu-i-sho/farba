module Make : INTEROPPOSITION_LINK.MAKE_T = functor
  (Key : ORDERABLE_AND_OPPOSABLE.T) -> struct
    include Link.Make (Key)
	
    let join a ~with':b ~by:key = 
      let rec a' = link a ~to':b' ~by:key
          and b' = link b ~to':a' ~by:(Key.opposite key) in
      a'
  end

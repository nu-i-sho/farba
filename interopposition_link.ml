module Make : INTEROPPOSITION_LINK.MAKE.T = functor
  (Key : ORDERED_AND_OPPOSABLE.T)
    (Value : EMPTIBLE.T) = 
  struct
    include Link.Make (Key) (Value)

    let join a ~with':b ~by:key = 
      let rec a' = link a ~to':b' ~by:key
          and b' = link b ~to':a' ~by:(Key.opposite key) in
      a'
  end   

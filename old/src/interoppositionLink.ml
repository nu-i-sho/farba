module Make : INTEROPPOSITION_LINK.MAKE_T = functor
  (Key : ORDERABLE_AND_OPPOSABLE.T) -> struct
    include Link.MakeForExtend (Key)

    let join a ~with':b ~by:key = 
      let rec a' = { a with links = (key, b') :: a.links }
          and b' = { b with links = ((Key.opposite key), a') :: b.links } 
      in 
      a'
  end

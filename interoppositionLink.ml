module Make : INTEROPPOSITION_LINK.MAKE_T = functor
  (Key : ORDERABLE_AND_OPPOSABLE.T) -> struct
    module Links = Map.Make (Key)
    include Link.MakeForExtend (Key) (Links)

    let join a ~with':b ~by:key = 
      let rec a' = lazy { a with links = a.links |> Links.add key (Lazy.force b') }
          and b' = lazy { b with links = b.links |> Links.add (Key.opposite key) (Lazy.force a') }
      in Lazy.force a'
  end

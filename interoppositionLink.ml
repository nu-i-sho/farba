module Make : INTEROPPOSITION_LINK.MAKE_T = functor
  (Key : ORDERABLE_AND_OPPOSABLE.T) -> struct
    module Links = Map.Make (Key)
    include Link.MakeForExtend (Key) (Links)

    let join a ~with':b ~by:key = 
      let rec a' = { a with links = a.links |> Links.add key b' }
          and b' = { b with links = b.links |> Links.add (Key.opposite key) a' }
      in a'
  end

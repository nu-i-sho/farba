include InteroppositionLink.Make (Hand)

let load source = 
  let links = List.map make source in
  let open Hand in
  List.fold_left 
    (fun a b -> join a ~with':b ~by:Right)
    (List.hd links)
    (List.tl links)

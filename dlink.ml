include Interopposition_link.Make (Hand)

let load_from source = 
  let links = List.map make_with source in
  let open Hand in
  List.fold_left 
    (fun a b -> join a ~with':b ~by:Right)
    List.hd links
    List.tl links

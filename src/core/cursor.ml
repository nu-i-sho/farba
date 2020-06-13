type t = Tissue.t
      
let make tissue = tissue
let tissue o = o
let position = Tissue.cursor
let is_clotted = Tissue.has_clot
let is_out_of_tissue o =
  Tissue.is_out_of (position o) o
  
let turn hand o =
  let i = o |> position in
  let n = o |> Tissue.nucleus i
            |> Nucleus.turn hand in
  Tissue.set_nucleus i n o

let move o =
  let i = position o in
  let open Pigment in

  match Tissue.cytoplasm i o with
  | Blue | Gray -> o
  | White       ->
     let n  = o |> Tissue.nucleus i in
     let o  = o |> Tissue.remove_nucleus i
     and i' = i |> Tissue.Coord.move n.gaze in
     ( match (o |> Tissue.nucleus_opt   i'),
             (o |> Tissue.cytoplasm_opt i') with
       |  None,     None                -> Tissue.set_nucleus i' n 
       |  None,    (Some c')            -> let n' = Nucleus.inject c' n in
                                           Tissue.set_nucleus i' n' 
       | (Some _), (Some White)         -> let n' = Nucleus.rev_gaze n in
                                           Tissue.set_nucleus i  n'
       | (Some _), (Some (Blue | Gray)) -> Tissue.set_clot i'
       | (Some _),  None                -> assert false
     ) o

  let replicate gene o =
    let i = position o in
    let open Pigment in
  
    match Tissue.cytoplasm i o with
    | White        -> o
    | Blue | Gray  ->
       let parent = Tissue.nucleus i o in
       let j = Tissue.Coord.move parent.gaze i 
       and child  = Nucleus.replicate gene parent in
       ( match (Tissue.nucleus_opt j o),
               (Tissue.cytoplasm_opt j o) with
         |  None,     None                -> Tissue.set_nucleus j child 
         |  None,    (Some c)             -> let n = Nucleus.inject c child in
                                             Tissue.set_nucleus j n 
         | (Some _), (Some White)         -> Tissue.set_clot i
         | (Some _), (Some (Blue | Gray)) -> Tissue.set_clot j
         | (Some _),  None                -> assert false
       ) o

  let pass o =
    let i  = position o in
    let donor = Tissue.nucleus i o in
    let i' = Tissue.Coord.move donor.gaze i in
    
    match Tissue.nucleus_opt i' o with
    | None           -> o
    | Some recipient ->
       let face_to_face =
         donor.gaze == (Side.rev recipient.gaze) in
       if face_to_face then
         o |> Tissue.set_cursor i' else
         o

  exception Clotted
  exception Out_of_tissue
        
  let perform command o =
    if o |> is_clotted then raise Clotted else
    if o |> is_out_of_tissue then raise Out_of_tissue else
      ( match command with
        | Command.Replicate gene   -> replicate gene
        | Command.Turn hand        -> turn hand
        | Command.Move Nature.Body -> move
        | Command.Move Nature.Mind -> pass
      ) o

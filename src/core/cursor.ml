module Make (Tissue : module type of Tissue) = struct
  module Position = struct
    type t =
      | InTissue    of  Tissue.Coord.t
      | OutOfTissue of (Tissue.Coord.t * Nucleus.t)
    end
    
  type t =
    { position : Position.t;
        tissue : Tissue.t
    }
      
  let make coord tissue =
    { position = Position.InTissue coord;
        tissue   
    }

  let tissue o = o.tissue
  let position o =
    match o.position with
    | Position.(InTissue i | OutOfTissue (i, _)) -> i
                                                  
  let is_clotted o = Tissue.has_clot o.tissue
  let is_out_of_tissue o = 
    match o.position with
    | Position.OutOfTissue _ -> true
    | Position.InTissue    _ -> false 

  let set i nucleus o =
    let t = o.tissue in
    if Tissue.is_out_of i t then
      let p = Position.(OutOfTissue (i, nucleus)) in
      { position = p;
          tissue = t
      } else
    
      ( match Tissue.nucleus_opt i t with
        | Some _ -> Tissue.set_clot i t
        | None   -> let c = Tissue.cytoplasm i t in
                    let n = Nucleus.inject c nucleus in
                    Tissue.set_nucleus i n t
      ) |> make i
     
  let turn hand o =
    let t = o.tissue
    and i = position o in
    let n = t |> Tissue.nucleus i
              |> Nucleus.turn hand in
    t |> Tissue.set_nucleus i n
      |> make i

  let move o =
    let i = position o
    and t = o.tissue in
    let n = Tissue.nucleus i t in
    let j = Tissue.Coord.move n.gaze i in

    let from_cyto, to_cyto =
      (Tissue.cytoplasm i t),
      (Tissue.cytoplasm j t) in

    Pigment.(
      match from_cyto , to_cyto  with
      | (White, _)    |    (_, White) -> set j n
      | (Blue | Gray) , (Blue | Gray) -> Fun.id
    ) o
  
  let replicate gene o =
    let i = position o
    and t = o.tissue in
    let open Pigment in
  
    match Tissue.cytoplasm i t with
    | White        -> o
    | Blue | Gray  ->
       let parent = Tissue.nucleus i t in
       let j = Tissue.Coord.move parent.gaze i
       and child  = Nucleus.replicate gene parent in   
       set j child o

  let pass o =
    let i = position o and t = o.tissue in
    let donor = Tissue.nucleus i t in
    let j = Tissue.Coord.move donor.gaze i in
  
    match Tissue.nucleus_opt j t with
    | None           -> o
    | Some recipient ->
       let face_to_face =
         (Side.rev recipient.gaze) == donor.gaze in
       if face_to_face then
         make j t else
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
  end

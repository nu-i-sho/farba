open Common

type position =
  | InTissue of Tissue.Coord.t
  | OutOfTissue of
      { nucleus : Nucleus.t;
          coord : Tissue.Coord.t
      }
    
type t = { position : position;
             tissue : Tissue.t
         }
      
let make coord tissue =
  { position = InTissue coord;
      tissue   
  }

let tissue   o = o.tissue
let position o =
  let (InTissue i | OutOfTissue { coord = i; _ }) =
    o.position in
  i
  
let is_in i o =
  match o.position with
  | InTissue j when j = i      -> true
  | InTissue _ | OutOfTissue _ -> false

let is_out_of_tissue o = 
  match o.position with
  | OutOfTissue _ -> true
  | InTissue _    -> false 

let tissue_is_cloted o =
  match Tissue.clot o.tissue with
  | Some _ -> true
  | None   -> false

let inject i nucleus tissue =
  if Tissue.out_of_range i tissue then
    { position = OutOfTissue { nucleus; coord = i };
        tissue
    } else
    ( match Tissue.maybe_nucleus i tissue with
      | Some _ -> Tissue.set_clot i tissue
      | None   -> let cytoplasm = Tissue.cytoplasm i tissue in
                  let nucleus = Nucleus.inject cytoplasm nucleus in
                  Tissue.set_nucleus i nucleus tissue
    ) |> make i
     
let turn hand o =
  let i = position o in
  let nucleus =
    o.tissue |> Tissue.nucleus i
             |> Nucleus.turn hand in
  o.tissue |> Tissue.set_nucleus i nucleus
           |> make i
  
let move o =
  let x = tissue o and i = position o in
  match Tissue.cytoplasm i x with
  | Blue | Gray -> o
  | White       -> let nucleus = Tissue.nucleus i x in
                   let x = Tissue.remove_nucleus i x
                   and j = Tissue.Coord.move nucleus.gaze i in
                   inject j nucleus x

let replicate relation o =
  let x = tissue o and i = position o in
  match Tissue.cytoplasm i x with
  | White       -> o
  | Blue | Gray -> let parent = Tissue.nucleus i x in
                   let j = Tissue.Coord.move parent.gaze i
                   and child = Nucleus.replicate relation parent in   
                   inject j child x

let pass o =
  let i = position o in
  let donor = Tissue.nucleus i o.tissue in
  let j = Tissue.Coord.move donor.gaze i in
  match Tissue.maybe_nucleus j o.tissue with
  | None           -> o
  | Some recipient ->
     if (Side.opposite recipient.gaze) == donor.gaze then
       { o with
         position = InTissue j
       } else
       o

exception Tissue_is_clotted
exception Out_of_tissue
        
let act action o =
  if tissue_is_cloted o then raise Tissue_is_clotted else
  if is_out_of_tissue o then raise Out_of_tissue else
    ( match action with
      | Replicate relation -> replicate relation
      | Turn hand          -> turn hand
      | Move Matter        -> move
      | Move Spirit        -> pass
    ) o

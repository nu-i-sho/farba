type t = {    kind : Gene.OfFlesh.Kind.t;
            spirit : RNA.t option;
           program : Gene.OfFlesh.Command.t array;
         }

let kind_of dna = dna.kind
let spirit_of dna = dna.spirit
let program_of dna = dna.program

let cytoplazm pigment = 
  {    kind = Gene.OfFlesh.Kind.Cytoplazm pigment;
     spirit = None; 
    program = [||];
  }

let turn side dna = 

  let open Gene.OfFlesh.Kind in
  let turn' = HexagonSide.turn ~to':side in 
  let kind  = match kind_of dna with
              | Nucleus (p, gaze) -> Nucleus (p, turn' gaze)
	      | Celluar (p, gaze) -> Celluar (p, turn' gaze)
  in
  
  { dna with kind }

let state_of nuclausable_kind = 
  let open Gene.OfFlesh.Kind in
  match nuclausable_kind with
  | Nucleus (p, g)
  | Celluar (p, g) -> (p, g)

let replicate relationship 
       ~donor:donor_dna 
    ~acceptor:maybe_acceptor_dna = 

  let donor_pigment, donor_gaze = 
    state_of (kind_of donor_dna) 
  in

  let acceptor_gaze' = 
    HexagonSide.opposite donor_gaze 
  in

  let open Relationship in
  let acceptor_pigment' = 
    match relationship with 
    | Direct  -> donor_pigment
    | Inverse -> Pigment.opposite donor_pigment
  in
  
  let maybe_acceptor_kind = 
    match maybe_acceptor_dna with
    | Some dna -> Some (kind_of dna)
    | None     -> None
  in

  let open Gene.OfFlesh.Kind in
  let acceptor_kind' = 
    match maybe_acceptor_kind with
    | Some (Cytoplazm p) when p = acceptor_pigment'
                         -> Celluar (acceptor_pigment', acceptor_gaze')
    | None               -> Nucleus (acceptor_pigment', acceptor_gaze')
    | Some (Cytoplazm _) -> Cancer
    | Some (Nucleus   _) -> Clot
    | Some (Celluar   _) -> Clot
  in
 
  let acceptor_dna' = { donor_dna with kind = acceptor_kind' } in
  let acceptor_dna' = if Clot = acceptor_kind' then
			{ acceptor_dna' with spirit = None } else
                          acceptor_dna'
  in

  let Some donor_spirit = spirit_of donor_dna in 
  let donor_spirit_kind = RNA.kind_of donor_spirit in
  let open Gene.OfSpirit.Kind in
  let donor_dna' = 
    match donor_spirit_kind with 
    | Gene.OfSpirit.Kind.ReinjectingVirus _
        -> { donor_dna with spirit = None }
    | _ ->   donor_dna
  in

  donor_dna', acceptor_dna'

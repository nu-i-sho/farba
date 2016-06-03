type t = | Procaryotic of Procaryote.t
         | Eucaryotic of Eucaryote.t
       
let replicate relationship ~donor:d ~acceptor:a = 
  let parent, child = 
    Eucaryote.replicate relationship d 
  in
  
  let open Procaryote in
  let open Eucaryote in
  match child with
  | Cancer -> 
     (Eucaryotic Cancer), 
     (Eucaryotic Cancer)

  | Nucleus x -> 
     match a with 
     | None -> 
	(Eucaryotic parent), 
	(Eucaryotic child)

     | Some (Eucaryotic _) -> 
	(Eucaryotic parent, 
	 Eucaryotic Cancer)

     | Some (Procaryotic Clot) -> 
	(Procaryotic Clot), 
	(Procaryotic Clot)

     | Some (Procaryotic (Cytoplazm c)) ->
	let Nucleus o = child in
	if (Nucleus.pigment_of o) == (Cytoplazm.pigment_of c) 
	then  
	  (Eucaryotic parent),
	  (Eucaryotic Cancer) 
	else
	  (Eucaryotic parent),
	  (Eucaryotic (Celluar.make o)) 

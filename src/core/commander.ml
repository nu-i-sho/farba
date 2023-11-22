module TTissue = TransTissue.Make(Tissue)

type t =
  | Unsolved of Tissue.t
  | NoVirus  of Tissue.t
  | Solved   of Tissue.t

let make tissue =
  if Tissue.is_resolved tissue then
    Solved   tissue else
  if Tissue.has_viruses tissue then
    Unsolved tissue else
    NoVirus  tissue 
    
  
let turn hand i o =
   o |> TTissue.add_nucleus i
         (o |> TTissue.Alive.nucleus i
            |> Nucleus.Alive.turn hand)

let move i o =
  let c = o |> TTissue.Alive.cytoplasm i
  and n = o |> TTissue.Alive.nucleus i in

  match Nucleus.Alive.extract c n with
  | Nucleus.Alive.Extraction.Retracted n           ->
                        o |> TTissue.add_nucleus    i n     
  | Nucleus.Alive.Extraction.Extracted n           ->
    let j = HexCoord.move (Nucleus.Alive.gaze n) i in
    match TTissue.cytoplasm_opt j o with
    | None                                         ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
    | Some d                                       ->
      match Nucleus.Alive.inject d n with
      | Nucleus.Alive.Injection.Rejected n         ->
                        o |> TTissue.add_nucleus    i n
          
      | Nucleus.Alive.Injection.Injected n         ->
        let v = TTissue.virus i o in
        match TTissue.nucleus_opt j o with
        | None                                     ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.add_nucleus    j n
                          |> TTissue.add_virus      j v
        | Some m                                   ->
          match Nucleus.merge n m with
          | Nucleus.Merge.NucleiDissolved          ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.remove_nucleus j
                          |> TTissue.remove_virus   j
                            
          | Nucleus.Merge.CytoplasmClosed d        ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.remove_nucleus j
                          |> TTissue.add_cytoplasm  j d
                            
          | Nucleus.Merge.NucleiMerged m           ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.add_nucleus    j m
                          |> TTissue.add_virus      j v
                            
          | Nucleus.Merge.NucleiClotted m          ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.add_nucleus    j m


let replicate gene i o =
  let c = o |> TTissue.Alive.cytoplasm i
  and n = o |> TTissue.Alive.nucleus i in
   
  match Nucleus.Alive.replicate gene c n with
  | Nucleus.Alive.Replication.ReplicatedIn  m      ->
    (match Nucleus.merge n m with
     | Nucleus.Merge.NucleiDissolved               ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                            
     | Nucleus.Merge.CytoplasmClosed d             ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.add_cytoplasm  i d

     | Nucleus.Merge.NucleiClotted m               ->
                        o |> TTissue.add_nucleus    i m
                          |> TTissue.remove_virus   i
                                                      
     | Nucleus.Merge.NucleiMerged m                ->
                        o |> TTissue.add_nucleus    i m)
    
  | Nucleus.Alive.Replication.ReplicatedOut m      ->
    let j = HexCoord.move (Nucleus.Alive.gaze n) i in
    match TTissue.cytoplasm_opt j o with
    | None                                         ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
    | Some d                                       ->
      match Nucleus.Alive.inject d n with
      | Nucleus.Alive.Injection.Rejected m         ->
        (match Nucleus.merge n m with
         | Nucleus.Merge.NucleiDissolved           ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                            
         | Nucleus.Merge.CytoplasmClosed d         ->
                        o |> TTissue.remove_nucleus i
                          |> TTissue.remove_virus   i
                          |> TTissue.add_cytoplasm  i d

         | Nucleus.Merge.NucleiClotted m           ->
                        o |> TTissue.add_nucleus    i m
                          |> TTissue.remove_virus   i
                                                   
         | Nucleus.Merge.NucleiMerged m            ->
                        o |> TTissue.add_nucleus    i m)

      | Nucleus.Alive.Injection.Injected m         ->
        (match Nucleus.merge n m with
         | Nucleus.Merge.NucleiDissolved           ->
                        o |> TTissue.remove_nucleus j
                            
         | Nucleus.Merge.CytoplasmClosed d         ->
                        o |> TTissue.remove_nucleus j
                          |> TTissue.add_cytoplasm  j d

         | Nucleus.Merge.NucleiClotted m           ->
                        o |> TTissue.add_nucleus    j m
             
         | Nucleus.Merge.NucleiMerged  m           ->
                        o |> TTissue.add_nucleus    j m)
             
let perform virus command = function
  | ((Solved   _) as o)
  | ((NoVirus  _) as o) -> o
  |   Unsolved tissue   ->
    let perform =
      match command with
      | Command.Turn hand      -> turn hand
      | Command.Move           -> move
      | Command.Replicate gene -> replicate gene
      | Command.Pass           -> failwith "Not implemented"
    and viruses = Tissue.viruses_coords virus tissue in
    tissue |> TTissue.open'
           |> List.fold_right perform viruses  
           |> TTissue.close
           |> make

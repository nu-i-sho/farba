type t = Data.TissueItemUpdate.t
open Data
       
let of_change previous current =
  let open TissueItemUpdate in
  let open TissueItem in
  match previous, current with
  | Cytoplasm p, Active c -> Inject (p, c)
  | Active p, Cytoplasm c -> Extract (p, c)
  | Static p, Active c    -> Infect (p, c)
  | Active p, Static c    -> VirusOut (p, c)
  | Static p, Clot c      -> DoClot (p, c)
  | Out, Outed c          -> MoveOut c
  | _                     -> failwith Fail.impossible_case

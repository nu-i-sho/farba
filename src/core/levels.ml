type e = (module LEVEL.S)
type t = e array

let std : t =
  [| (module Level_001);
     (module Level_002);
     (module Level_003);
     (module Level_004);
     (module Level_005);
     (module Level_006);
     (module Level_007);
     (module Level_008);
     (module Level_009);
  |]

let get level o  = 
  try o.(pred level) with
  | Invalid_argument _ -> raise Not_found
 
let get_opt level o =
  try Some (get level o) with
  | Not_found -> None

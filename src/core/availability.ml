type 'a t =
  | Enabled of 'a 
  | Disabled of 'a

let enable  (Enabled x | Disabled x) = Enabled x
let disable (Enabled x | Disabled x) = Disabled x

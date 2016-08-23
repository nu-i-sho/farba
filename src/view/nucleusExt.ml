type t = Data.Nucleus.t
open Data
   
let is_cancer o =
  Nucleus.(o.pigment = Pigment.White)

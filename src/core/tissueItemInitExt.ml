type t = Data.TissueItemInit.t
open Data
       
let of_tissue_item =
  let module Init = TissueItemInit in
  let module Item = TissueItem in
  function | Item.Clot _
           | Item.Outed _     -> failwith Fail.impossible_case     
           | Item.Cytoplasm c -> Init.Cytoplasm c
           | Item.Active c    -> Init.Active c
           | Item.Static c    -> Init.Static c
           | Item.Out         -> Init.Out

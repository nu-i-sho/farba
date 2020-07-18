type e =
  {     id : int;
    tissue : Tissue.t
  }
  
type t = (unit -> Tissue.t) array

let std =
  [| Level_001.build_tissue; 
     Level_002.build_tissue;
     Level_003.build_tissue;
     Level_004.build_tissue;
     Level_005.build_tissue;
     Level_006.build_tissue;
     Level_007.build_tissue;
     Level_008.build_tissue;
     Level_009.build_tissue
  |]

let get level o =
  {     id = level;
    tissue = o.(pred level) ()
  }

module type T = sig
    type t

    val set   : Index.t -> ColonyItem.t -> t -> t
    val reset : Index.t 
             -> previous : AnatomyItem.t 
             ->  current : TissueItem.t 
             -> t 
             -> t
  end

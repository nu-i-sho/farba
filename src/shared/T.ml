module type ANATOMY_OBSERVER = sig
    type t

    val set   : Data.Pigment.t -> t -> t
    val reset : previous: Data.AnatomyItem.t
             ->  current: Data.AnatomyItem.t
             -> t
             -> t
  end

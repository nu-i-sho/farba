module type ANATOMY_OBSERVER = sig
    type t

    val set     : (int * int) -> Data.Pigment.t -> t -> t
    val set_out : (int * int) -> Data.Nucleus.t -> t -> t
    val reset   : (int * int)
               -> previous: Data.AnatomyItem.t
               ->  current: Data.AnatomyItem.t
               -> t
               -> t
  end

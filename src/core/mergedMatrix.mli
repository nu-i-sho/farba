module Merge (Fst : MATRIX.T)
             (Snd : MATRIX.T)
             (Res : sig type e end) : sig

    include MATRIX.T with type e = Res.e

    val merge   : (Fst.e -> Snd.e -> e) -> Fst.t -> Snd.t -> t
    val fst     : t -> Fst.t
    val snd     : t -> Snd.t
    val set_fst : Fst.t -> t
    val set_snd : Snd.t -> t
    
end

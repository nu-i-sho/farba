type t

val default : t

module Command : sig
    val act     : t -> (char -> Graphics.color)
    val finish  : t -> (char -> Graphics.color)
    val declare : t -> (char -> Graphics.color)
    val call    : t -> (char -> Graphics.color)
  end

module CallStackPoint : sig
    val run  : t -> (char -> Graphics.color)
    val find : t -> (char -> Graphics.color)
  end

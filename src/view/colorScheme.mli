type t

val default : t

module ForCommand : sig
    val map_for_act     : t -> (char -> Graphics.color)
    val map_for_end     : t -> (char -> Graphics.color)
    val map_for_declare : t -> (char -> Graphics.color)
    val map_for_call    : t -> (char -> Graphics.color)
  end

module ForCallStackPoint : sig
    val map_for_run  : t -> (char -> Graphics.color)
    val map_for_find : t -> (char -> Graphics.color)
  end

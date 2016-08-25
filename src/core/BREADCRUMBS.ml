module type T = sig
    type t

    val mode      : t -> Data.RuntimeMode.t
    val with_mode : Data.RuntimeMode.t -> t -> t
    val top       : t -> Data.Crumb.t
    val move      : t -> t
    val back      : t -> t
    val split     : t -> t
  end

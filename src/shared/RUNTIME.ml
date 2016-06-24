module type T = sig
    type t

    val with_mode      : RuntimeMode.t -> t -> t
    val mode_of        : t -> RuntimeMode.t
    val tick           : t -> t
    val active_command : t -> Command.t
  
  end

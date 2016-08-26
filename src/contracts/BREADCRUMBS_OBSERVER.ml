module type T = sig
    type t
    val init : Data.Crumb.t -> Data.RuntimeMode.t -> t -> t
    val update_top_crumb : Data.Crumb.t -> Data.Crumb.t -> t -> t
    val update_mode : Data.RuntimeMode.t
                   -> Data.RuntimeMode.t
                   -> t
                   -> t
  end

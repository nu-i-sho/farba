open Data
module type T = sig
    type t
    
    val update_mode : RuntimeMode.t -> RuntimeMode.t -> t -> t 
    val update_top_crumb : Crumb.t -> Crumb.t -> t -> t
    val init : Command.t array -> Crumb.t -> RuntimeMode.t -> t -> t
  end

open Data
module type T = sig
    type t
     
    val init  : Command.t array -> RuntimePoint.t -> t -> t
    val reset : RuntimePoint.t -> RuntimePoint.t -> t -> t
  end

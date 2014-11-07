module type T = sig
  type state_t 

  val set_up   : unit -> state_t
  val tir_down : state_t -> unit
  val tests    : (state_t Test.t) list
end

module type T = sig
  include NAMED.T
  val run : unit -> unit
end

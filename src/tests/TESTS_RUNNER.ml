module type T = sig
  type t
  val make  : output:(string -> unit) -> t
  val run   : (module TEST_FIXTURE.T) -> t -> unit
  val run_s : (module TEST_FIXTURE.T) list -> t -> unit
end

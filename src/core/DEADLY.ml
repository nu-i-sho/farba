module type T = sig
  type t

  module Alive : T.T
  module Dead  : T.T

  val is_alive     : t -> bool
  val is_dead      : t -> bool
  val of_alive     : Alive.t -> t
  val of_dead      : Dead.t -> t
  val to_alive_opt : t -> Alive.t option
  val to_dead_opt  : t -> Dead.t option
  end

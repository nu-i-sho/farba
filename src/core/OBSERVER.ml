module type S = sig
  type event
  type t
  val send : event -> t -> t
  end

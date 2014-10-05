module Make(Dir : Idir.T)(Value : Iemptible.T) = sig
  include Iemptible.T 

  val make_with : Value.t -> t
  val value_of  : t -> Value.t
  val go_to     : Dir.t -> ~from:t -> t
  val join      : t -> t -> Dir.t -> t
end

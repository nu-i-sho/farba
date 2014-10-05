module type T = sig
  include Iemptible.T

  val keys : Set.S with elt = t
end

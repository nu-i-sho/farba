module MAKE (Packed : sig type t end) = struct
  module type S = sig
    type t
    val pack   : Packed.t -> t -> t
    val unpack : t -> Packed.t
    end
  end

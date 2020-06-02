type event = int

module OBSERVER : sig
  module type S = OBSERVER.S with type event = event
  end
           
module Make :
  functor (Base : module type of Tissue) -> sig
    include module type of Tissue
    module OBSERVER : module type OBSERVER 
    type nonrec event = event

    val subscribe   : (module OBSERVER with type t = 't) -> 't -> t
                                           -> (subscription * t)
    val subscribe_f : (event -> unit) -> t -> (subscription * t)
    val unsubscribe : subscription -> t -> t
  end

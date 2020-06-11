module Make :
  functor (Event : sig type t end) -> sig
    include OBSERV.ABLE.S with type event  = Event.t
    include OBSERV.ER.S   with type event := event
                           and type t := t
    val empty : t
    end

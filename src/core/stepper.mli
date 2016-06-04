module Mode : sig
    type t = | Run
             | Find
             | Return
end

module Event : sig
    type t = | ModeChanged of (Mode.t * Mode.t)
	     | Breadcrumbs of Breadcrumbs.Event.t
end

type t

val start       : t
val starto      : observer:(Event.t -> unit) -> t
val position_of : t -> int
val set_mode    : Mode.t -> t -> t
val step        : t -> t 

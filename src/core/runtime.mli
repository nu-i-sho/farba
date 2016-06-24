type t

module Mode : sig
    type t = | Run
	     | Find of DotsOfDice.t
	     | Return of DotsOfDice.t
  end

val make : breadcrumbs : Breadcrumbs.t 
        ->     program : Program.t 
        -> t

val with_mode      : Mode.t -> t -> t
val mode_of        : t -> Mode.t
val tick           : t -> t
val active_command : t -> Command.t

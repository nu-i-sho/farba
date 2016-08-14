module Make (Prototypes : IMAGE_PROTOTYPES.T) : sig
    type t
    val make : ColorScheme.t -> t

    module Command : sig
        val get_for : Data.Command.t -> t -> Graphics.image
      end

    module CallStackPoint : sig
        val get_for : Data.DotsOfDice.t
                   -> Data.RuntimeMode.t
                   -> t
                   -> Graphics.image
      end
  end

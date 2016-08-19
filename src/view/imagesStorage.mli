module Make (Prototypes : CONTRACTS.PROTOIMAGES_STORAGE.T) : sig
    type t
    val make : CommandColorScheme.t
            -> CallStackPointColorScheme.t
            -> t

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

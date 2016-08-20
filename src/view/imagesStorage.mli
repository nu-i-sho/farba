module Make (Prototypes : CONTRACTS.PROTOIMAGES_STORAGE.T) : sig
    type t
    val make : CommandColorScheme.t
            -> CallStackPointColorScheme.t
            -> t

    module Command : sig
        val get : Data.Command.t
               -> t
               -> (Graphics.image, t) StateUpdatableResult.t
      end

    module CallStackPoint : sig
        val get : Data.DotsOfDice.t
               -> Data.RuntimeMode.t
               -> t
               -> (Graphics.image, t) StateUpdatableResult.t
      end
  end

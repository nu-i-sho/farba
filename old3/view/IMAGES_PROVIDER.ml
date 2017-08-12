module type T = sig
    type t
    type result_t

    module Command : sig
        val get : Data.Command.t -> t -> result_t
      end

    module CallStackPoint : sig
        val get : Data.DotsOfDice.t
               -> Data.RuntimeMode.t
               -> t
               -> result_t
      end
  end

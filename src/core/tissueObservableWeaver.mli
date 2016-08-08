module Subscribe (Observer : T.TISSUE_OBSERVER) : sig
    include COUNTABLE_WEAVER.T
    val subscribe : Observer.t -> CountableWeaver.t -> t
  end

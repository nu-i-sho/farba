module Subscribe (Observer : T.TISSUE_OBSERVER) : sig
    include WEAVER.COUNTABLE.T
    val subscribe : Observer.t -> CountableWeaver.t -> t
  end

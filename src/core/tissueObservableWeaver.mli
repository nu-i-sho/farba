module Subscribe (Observer : T.TISSUE_OBSERVER) : sig
    include STATISTICABLE_WEAVER.T
    val subscribe : Observer.t -> StatisticableWeaver.t -> t
  end

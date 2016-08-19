module Subscribe (Observer : Contracts.TISSUE_OBSERVER.T) : sig
    include STATISTICABLE_WEAVER.T
    val subscribe : Observer.t -> StatisticableWeaver.t -> t
  end

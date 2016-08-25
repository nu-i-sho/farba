module Subscribe (Observer : CONTRACTS.BREADCRUMBS_OBSERVER.T) : sig
    include BREADCRUMBS.T
    val subscribe : Observer.t -> t
  end

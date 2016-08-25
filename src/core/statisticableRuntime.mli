module Make (Crumbs : BREADCRUMBS.T)
            (Weaver : STATISTICABLE_WEAVER.T) : sig
    include RUNTIME.T with type crumbs_t = Crumbs.t
                       and type weaver_t = Weaver.t
    val statistics : t -> Data.Statistics.t
  end

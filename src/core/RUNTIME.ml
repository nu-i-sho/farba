module type T = sig
    type weaver_t
    type t
   
    val mode      : t -> Data.RuntimeMode.t
    val weaver    : t -> weaver_t
    val solution  : t -> Solution.t
    val top_crumb : t -> Data.Crumb.t
    val tick      : t -> (TickStatus.t, t) Statused.t
  end

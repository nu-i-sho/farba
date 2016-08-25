module type T = sig
    type crumbs_t
    type weaver_t
    type t

    val weaver   : t -> weaver_t
    val solution : t -> Solution.t
    val tick     : t -> (TickStatus.t, t) Statused.t
    val make     : Solution.t -> weaver_t -> crumbs_t -> t
end

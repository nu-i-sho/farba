module type T = sig
    type crumbs_t
    type weaver_t
    type t

    val stage    : t -> RuntimeStage.t
    val weaver   : t -> weaver_t
    val solution : t -> Solution.t
    val tick     : t -> t
    val make     : Solution.t -> weaver_t -> crumbs_t -> t
end

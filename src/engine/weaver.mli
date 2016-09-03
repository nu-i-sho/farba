module Make (D : DEPENDENCIES.WEAVER) : sig
    include CORE.WEAVER.T with type tissue_t = D.Core.Tissue.t
    val make : D.Core.Weaver.t -> D.View.Tissue.t -> t
  end

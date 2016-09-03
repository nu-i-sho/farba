module type WEAVER = sig
    module Core : sig
        module Tissue : CORE.TISSUE.T
        module Index  : CORE.INDEX.T
        module Weaver : CORE.STATISTICAL_WEAVER.T
               with type tissue_t = Tissue.t
      end

    module View : sig
        module Tissue : VIEW.TISSUE.T
      end
  end

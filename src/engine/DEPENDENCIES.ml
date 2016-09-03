module type WEAVER = sig
    module Core : sig
        module Tissue : CORE.TISSUE.T
        module Weaver : CORE.WEAVER.T with type tissue_t = Tissue.t
        module Index  : CORE.INDEX.T
      end

    module View : sig
        module Tissue : VIEW.TISSUE.T
      end
  end

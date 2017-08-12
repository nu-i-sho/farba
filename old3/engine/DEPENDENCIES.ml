module MAKE (CORE : MODULE.T)
            (VIEW : MODULE.T) = struct
    module type T = sig
        module Core : CORE.T
        module View : VIEW.T
      end
  end

module WEAVER = struct
    module CORE = struct
        module type T = sig
            module Tissue : CORE.TISSUE.T
            module Index  : CORE.INDEX.T
            module Weaver : CORE.STATISTICAL_WEAVER.T
                   with type tissue_t = Tissue.t
          end
      end

    module VIEW = struct
        module type T = sig
            module Tissue : VIEW.TISSUE.T
          end
       end

    include MAKE (CORE) (VIEW)
  end

module PROGRAM = struct
    module CORE = struct
        module type T = sig
            module Program : CORE.PROGRAM.T
          end
      end
         
    module VIEW = struct
        module type T = sig
            module Program : VIEW.PROGRAM.T
          end
      end
                
    include MAKE (CORE) (VIEW)
  end
               
module CORE = struct
    module type T = sig
        include WEAVER.CORE.T
        include PROGRAM.CORE.T    
      end
  end

module VIEW = struct
    module type T = sig
        include WEAVER.VIEW.T
        include PROGRAM.VIEW.T    
      end
  end

include MAKE (CORE) (VIEW)

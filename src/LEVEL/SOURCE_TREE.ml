module LEAF = struct
     module type T = sig
         type flora = string list lazy_t
         type fauna = string list lazy_t
                    
         include SOURCE.T
                 with type flora := flora
                  and type fauna := fauna
      end
  end

module BRANCHLET = SHARED.DOTS_NODE.MAKE (LEAF)
module BRANCH    = SHARED.DOTS_NODE.MAKE (BRANCHLET)
module ROOT      = SHARED.DOTS_NODE.MAKE (BRANCH)

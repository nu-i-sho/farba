module MAKE (ITEM : MODULE.T) = struct
    module type T = sig
        module OOOOOO : ITEM.T
        module OOOOO : ITEM.T
        module OOOO : ITEM.T
        module OOO : ITEM.T
        module OO : ITEM.T
        module O : ITEM.T
      end
  end

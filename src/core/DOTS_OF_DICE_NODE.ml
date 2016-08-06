module MAKE (ITEM : MODULE.T) = struct
    module type E = ITEM.T
    module type T = sig
	module OOOOOO : E
	module OOOOO : E
        module OOOO : E
	module OOO : E
	module OO : E
	module O : E		  
      end
  end

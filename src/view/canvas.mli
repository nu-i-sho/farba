module Make (Size : CANVAS.SIZE.T)
                  : CANVAS.T

module Resize (Canvas : CANVAS.T)
                (Size : CANVAS.SIZE.T)
                      : CANVAS.T

module Shift (Canvas : CANVAS.T) 
	      (Shift : CANVAS.SHIFT.T)
                     : CANVAS.T

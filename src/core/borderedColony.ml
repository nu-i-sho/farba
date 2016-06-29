module Decorate (Base : COLONY.T) = struct
    type t = Base.t
	   
    let height o = 2 + (Base.height o)
    let width  o = 2 + (Base.width  o)
    
    let get (x, y) o = 
      if y = 0 || y = (height o) - 1 || 
         x = 0 || x = (width  o) - 1 then 
	Data.Pigment.None else
	Base.get ((x + 1), (y + 1)) o
 
    let decorate base = 
      base
  end

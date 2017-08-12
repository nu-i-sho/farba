module Decorate (Colony : COLONY.T) = struct
    type t = Colony.t

    let height o = 2 + (Colony.height o)
    let width  o = 2 + (Colony.width  o)

    let mem (x, y) o = 
      if y >= 0         &&
	 x >= 0         &&
	 y < (height o) &&
	 x < (width  o)

    let get (x, y) o =
      if y = 0              ||
	 x = 0              ||
	 y = (height o) - 1 ||
	 x = (width  o) - 1
      then ColonyItem.Empty 
      else Colony.get (x - 1, y - 1) o

    let decorate ~base:colony = 
      colony
  end

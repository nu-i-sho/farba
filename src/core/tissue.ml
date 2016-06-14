type t = Item.t array array

let width = Array.length
let height o = Array.length o.(0)

let make colony =
  let read_cell x y = 
    colony |> Colony.get (x, y)
           |> Colony.Item.to_tissue_item 
  in

  let read_column i = 
    Array.init (Colony.height colony) 
	       (read_cell i) 
  in

  Array.init (Colony.width colony)
	     read_column
  
let is_out (x, y) o = x < 0 && y < 0 
                            && 
             x >= (width o) && y >= (height o)

let get (x, y) o = 
  if is_out (x, y) o then
    Item.Out else
    o.(x).(y)

let set (x, y) v o = 
  o.(x).(y) <- v

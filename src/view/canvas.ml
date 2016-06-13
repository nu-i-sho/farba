open Graphics

let set_color           = set_color
let set_line_width      = set_line_width
let draw_poly           = draw_poly
let draw_ellipse (x, y) = draw_ellipse x y
let draw_circle  (x, y) = draw_circle x y
let draw_arc     (x, y) = draw_arc x y
let fill_poly           = fill_poly
let fill_ellipse (x, y) = fill_ellipse x y
let fill_circle  (x, y) = fill_circle x y
let moveto       (x, y) = moveto x y
let lineto       (x, y) = lineto x y

module Shift (Canvas : CANVAS.T) 
	      (Shift : CANVAS.SHIFT.T) = struct
    
    let shift point =
      Pair.apply ((+) Shift.dx) 
                 ((+) Shift.dy)
		 point

    let set_color      = set_color
    let set_line_width = set_line_width    		 
    let draw_poly   ps = draw_poly (Array.map shift ps)
    let draw_ellipse p = draw_ellipse (shift p)
    let draw_circle  p = draw_circle (shift p)
    let draw_arc     p = draw_arc (shift p)
    let fill_poly   ps = fill_poly (Array.map shift ps)
    let fill_ellipse p = fill_ellipse (shift p)
    let fill_circle  p = fill_circle (shift p)
    let moveto       p = moveto (shift p)
    let lineto       p = lineto (shift p)

  end

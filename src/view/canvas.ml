include Graphics

let inv y       = size_y () - y
let invp (x, y) = x, (inv y)
    
let draw_poly ps        = draw_poly (Array.map invp ps)
let draw_ellipse (x, y) = draw_ellipse x (inv y)
let draw_circle  (x, y) = draw_circle x (inv y)
let draw_arc     (x, y) = draw_arc x (inv y)
let fill_poly ps        = fill_poly (Array.map invp ps)
let fill_ellipse (x, y) = fill_ellipse x (inv y)
let fill_circle  (x, y) = fill_circle x (inv y)
let moveto       (x, y) = moveto x (inv y)
let lineto       (x, y) = lineto x (inv y)

let draw_image img (x, y) = draw_image img x (inv y)
let blit_image img (x, y) = blit_image img x (inv y)

let get_image (x1, y1) (x2, y2) = 
  get_image x1 (inv y1) x2 (inv y2)


module Shift (Donor : CANVAS.T)
	     (Shift : CANVAS.SHIFT.T) = struct

    include Donor
    open Std

    let shift (x, y) = 
      (x + Shift.dx), 
      (y + Shift.dy)
		
    let draw_poly ps      = draw_poly (Array.map shift ps)
    let draw_ellipse p    = draw_ellipse (shift p)
    let draw_circle p     = draw_circle (shift p)
    let draw_arc p        = draw_arc (shift p)
    let fill_poly ps      = fill_poly (Array.map shift ps)
    let fill_ellipse p    = fill_ellipse (shift p)
    let fill_circle p     = fill_circle (shift p)
    let moveto p          = moveto (shift p)
    let lineto p          = lineto (shift p)
    let draw_image img p  = draw_image img (shift p)
    let blit_image img p  = blit_image img (shift p)
    let get_image p1 p2   = get_image (shift p1) (shift p2)
  
  end
 

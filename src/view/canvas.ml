module Make (Size : CANVAS.SIZE.T) = struct

    include Graphics

    let width               = Size.width
    let height              = Size.height
    let draw_ellipse (x, y) = draw_ellipse x y
    let draw_circle  (x, y) = draw_circle x y
    let draw_arc     (x, y) = draw_arc x y
    let fill_ellipse (x, y) = fill_ellipse x y
    let fill_circle  (x, y) = fill_circle x y
    let moveto       (x, y) = moveto x y
    let lineto       (x, y) = lineto x y
  
  end

module Resize (Canvas : CANVAS.T)
	        (Size : CANVAS.SIZE.T) = struct
    
    include Canvas

    let width  = Size.width
    let height = Size.height
	      
  end

module Shift (Canvas : CANVAS.T) 
	      (Shift : CANVAS.SHIFT.T) = struct
    
    include Canvas

    let shift point =
      Pair.apply ((+) Shift.dx) 
                 ((+) Shift.dy)
		 point

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

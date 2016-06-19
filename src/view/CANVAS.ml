module type T = sig
    
    val set_color      : Graphics.color -> unit
    val set_line_width : int -> unit
    val draw_poly      : Point.t array -> unit
    val draw_ellipse   : Point.t -> int -> int -> unit
    val draw_circle    : Point.t -> int -> unit
    val draw_arc       : Point.t -> int -> int -> int -> int 
		      -> unit
    val fill_poly      : Point.t array -> unit
    val fill_ellipse   : Point.t -> int -> int -> unit
    val fill_circle    : Point.t -> int -> unit
    val moveto         : Point.t -> unit
    val lineto         : Point.t -> unit
    val draw_image     : Graphics.image -> Point.t -> unit
    val create_image   : int -> int -> Graphics.image
    val get_image      : Point.t -> Point.t -> Graphics.image
    val blit_image     : Graphics.image -> Point.t -> unit
    val dump_image     : Graphics.image 
		      -> Graphics.color array array
    val make_image     : Graphics.color array array 
		      -> Graphics.image
  
  end

module SHIFT = struct
    module type T = sig
	val dx : int
	val dy : int
      end
  end

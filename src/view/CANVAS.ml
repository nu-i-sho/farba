module type T = sig

    val set_color      : Graphics.color -> unit
    val set_line_width : int -> unit
    val draw_poly      : (int * int) array -> unit
    val draw_ellipse   : int -> int -> int -> int -> unit
    val draw_circle    : int -> int -> int -> unit
    val draw_arc       : int -> int -> int -> int -> int -> int
                      -> unit
    val fill_poly      : (int * int) array -> unit
    val fill_ellipse   : int -> int -> int -> int -> unit
    val fill_circle    : int -> int -> int -> unit
    val moveto         : int -> int -> unit
    val lineto         : int -> int -> unit

end

type t
   
val open_window : int -> int -> unit
val root : t
val sub : int -> int -> t -> t
   
val set_color      : Graphics.color -> t -> t
val set_line_width : int -> t -> t
  
val draw_poly    : (int * int) array -> t -> t
val draw_ellipse : (int * int) -> int -> int -> t -> t
val draw_circle  : (int * int) -> int -> t -> t
val draw_arc     : (int * int) -> int -> int -> int -> int -> t -> t
val fill_poly    : (int * int) array -> t -> t
val fill_ellipse : (int * int) -> int -> int -> t -> t
val fill_circle  : (int * int) -> int -> t -> t
val moveto       : (int * int) -> t -> t
val lineto       : (int * int) -> t -> t

module Image : sig
    val draw   : Graphics.image -> (int * int) -> t -> t
    val create : int -> int -> Graphics.image
    val get    : (int * int) -> (int * int) -> t -> Graphics.image
    val blit   : Graphics.image -> (int * int) -> t -> unit
    val dump   : Graphics.image -> Graphics.color array array
    val make   : Graphics.color array array -> Graphics.image
  end

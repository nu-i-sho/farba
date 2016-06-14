module type T = sig
    type t

    val zero         : t
    val set_index    : Index.t -> t -> t
    val draw_hexagon : t -> t
    val fill_hexagon : t -> t
    val draw_nucleus : t -> t
    val fill_nucleus : t -> t
    val draw_eyes    : Eyes.t -> t -> t
    val fill_eyes    : Side.t -> t -> t

    val set_hels_pigment_as_color : HelsPigment.t -> t -> t
    val set_pigment_as_color      : Pigment.t -> t -> t
    val set_opposited_pigment_as_color 
	                          : Pigment.t -> t -> t
    val set_color_for_cancer      : t -> t 
    val set_color_for_clot        : t -> t
    val set_color_for_virus       : t -> t
    val set_color_for_line        : t -> t

  end

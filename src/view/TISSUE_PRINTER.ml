module type T = sig
    type t

    val zero         : t
    val set_index    : Index.t -> t -> t
    val set_color    : Graphics.color -> t -> t
    val draw_hexagon : t -> t
    val fill_hexagon : t -> t
    val draw_nucleus : t -> t
    val fill_nucleus : t -> t
    val draw_eyes    : Eyes.t -> t -> t
    val fill_eyes    : Side.t -> t -> t

  end

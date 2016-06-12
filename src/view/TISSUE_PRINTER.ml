module type T = sig
    type t

    val set_index    : Index.t -> t -> t
    val set_color    : Graphics.color -> t -> t
    val draw_hexagon : Index.t -> t -> t
    val fill_hexagon : Index.t -> t -> t
    val draw_nucleus : Index.t -> t -> t
    val fill_nucleus : Index.t -> t -> t
    val draw_eyes    : Index.t -> Eyes.t -> t -> t
    val fill_eyes    : Index.t -> t -> t

  end

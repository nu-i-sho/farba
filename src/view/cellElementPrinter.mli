type t

val make : Canvas.t -> Scale.t -> TissueColorScheme.t -> t

val set_index             : (int * int) -> t -> t
val set_color_for_pigment : Data.Pigment.t -> t -> t
val set_color_for_cancer  : t -> t
val set_color_for_clot    : t -> t
val set_color_for_virus   : t -> t
val set_color_for_line    : t -> t

val draw_hexagon : t -> t
val fill_hexagon : t -> t
val draw_nucleus : t -> t
val fill_nucleus : t -> t

val draw_open_eyes    : Data.Side.t -> t -> t
val fill_open_eyes    : Data.Side.t -> t -> t
val draw_engry_eyes   : Data.Side.t -> t -> t
val draw_clotted_eyes : Data.Side.t -> t -> t

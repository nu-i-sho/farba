type t =
  private | None
          | Inactive of Dots.t
          | Active of
              { i : Dots.t;
                n : Dots.t
              }

val make : Dots.t -> t
val iter : t -> t

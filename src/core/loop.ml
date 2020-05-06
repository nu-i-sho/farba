type t =
  | None
  | Inactive of Dots.t
  | Active   of
      { i : Dots.t;
        n : Dots.t
      }
      
let make n = Inactive n      
let iter = function
  | None       -> None
  | Inactive n -> Active { i = Dots.min; n }
  | Active   o ->
     if o.i = o.n then
       Inactive o.n else
       Active { o with
                i = Dots.succ o.i
              }

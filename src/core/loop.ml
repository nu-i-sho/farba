type t =
  | Unactive of Dots.t
  | Active of
      { i : Dots.t;
        n : Dots.t
      }
      
let make n = Unactive n
               
let iter = function
  | Unactive n -> Active { i = Dots.min; n }
  | Active   o ->
     if o.i = o.n then
       Unactive o.n else
       Active { o with
                i = Dots.succ o.i
              }

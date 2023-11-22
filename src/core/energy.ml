module Make = functor (Num : SEQUENTIAL.T) -> struct

  module Call   = struct type t = Num.t end
  module Wait   = struct type t = Num.t end                   
  module Find   = struct type t = Num.t end                   
  module Open   = struct type t = Num.t end
  module Close  = struct type t = Num.t end
  module Return = struct type t = Num.t end
       
  let origin  = Num.min
  let find  x = x, x
  let open' x = (Num.succ x), (Num.succ x)
  let close x = x
  
  let return x y =
    if x = y then
      Some (Num.pred x) else 
      None
  
  let done' x y =
    if x = y then
      Some x else
      None
  end

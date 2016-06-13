type 'a t = 'a * 'a

let map f (x, y) = 
  (f x), (f y)

let iter f o =
  ignore(map f o)

let apply f g (x, y) =
  (f x), (g y)

let foldl f (x0, y0) (x1, y1) = 
  (f x0 x1), (f y0 y1)

let foldr f (x0, y0) (x1, y1) = 
  (f x1 x0), (f y1 y0)

type 'a t = 'a * 'a

let map f (x, y) = 
  (f x), (f y)

let iter f o =
  ignore(map f o)

let sum f (x0, y0) (x1, y1) = 
  (f x0 x1), (f y0 y1)

let fold f acc (x, y) =
  (f (f acc x) y)

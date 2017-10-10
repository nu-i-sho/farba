type ('a, 'b) t = 'a * 'b

let make a b = a, b
let map f (a, b) = (f a), (f b)

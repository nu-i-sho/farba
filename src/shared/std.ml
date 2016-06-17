let (~<|) f x y  = f y x
let (~<||) f x y z = f z x y
let (~<<|) f x y z = f y z x
let (||>) (x, y) f = f x y

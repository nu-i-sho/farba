type source_t  = char
type product_t = Color.t

let convert = 
  let open Color in 
  function | '1' -> Red
           | '2' -> Orange
           | '3' -> Yellow
           | '4' -> Green
           | '5' -> Blue
           | '6' -> Violet
	

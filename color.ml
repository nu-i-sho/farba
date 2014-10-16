type t = | Red
         | Orange
	 | Yellow
	 | Green
	 | Blue
	 | Violet

type source_t = char
let parse = function 
  | '0' -> Red
  | '1' -> Orange
  | '2' -> Yellow
  | '3' -> Green
  | '4' -> Blue
  | '5' -> Violet

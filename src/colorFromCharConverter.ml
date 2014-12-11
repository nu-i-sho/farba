include UnitMakeable

type source_t = char
type product_t = Color.t

let convert chr () =
  Color.( match chr with
          | '1' -> Red
          | '2' -> Orange
          | '3' -> Yellow
          | '4' -> Green
          | '5' -> Blue
          | '6' -> Violet
	)

module Make 
  (Color : T.T) 
  (Cell : CELL.T with type color_t = Color.t) 
  (CConv : FROM_CHAR_CONVERTER.T with type product_t = Color.t) =
  
  struct
    include UnitMakeable

    type source_t = Color.t
    type product_t = Cell.t

    let cconv = CConv.make ()
    let convert = function
      | '-' -> fun () -> Cell.empty
      | oth -> fun () -> Cell.Expect (cconv |> CConv.convert oth)
  end

include Make (Color) (Cell) (ColorFromCharConverter)

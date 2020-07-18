let build_tissue () =
  let module B = Tissue.Builder in
  B.empty
    |> B.add_cytoplasm Pigment.White
    |> B.move_coord    Side.Down
    |> B.add_cytoplasm Pigment.Blue
    |> B.add_nucleus   Pigment.Blue Side.LeftUp
    |> B.set_cursor
    |> B.move_coord    Side.Down
    |> B.add_cytoplasm Pigment.White
    |> B.product

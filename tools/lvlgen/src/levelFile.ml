let create src name =
  let outline file str =
    List.iter (output_string file) [ str; Const.end_line ] in
  let level = open_out (Str.ml_file name) in
  let () = List.iter (outline level) src in
  close_out level

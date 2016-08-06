let file name ext = name ^ "." ^ ext
let ml_file name = file name Const.ml_ext
let start_with_lowercase str  =
  let result = Bytes.copy str in
  let () = Bytes.set result 0 (Char.lowercase result.[0]) in
  result

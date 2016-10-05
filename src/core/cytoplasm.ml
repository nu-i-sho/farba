open Data.Shared
open Shared.Fail
type t = pigment

let of_char =
  function | 'O' -> Gray
           | '0' -> Blue
           | '.' -> White
           |  _  -> raise (Inlegal_case "Core.cytoplasm.of_char")

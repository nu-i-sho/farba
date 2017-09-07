open Common

type t = pigment

let opposite =
  function | White -> White
           | Blue  -> Gray
           | Gray  -> Blue

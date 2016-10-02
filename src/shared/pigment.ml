open Data.Shared
type t = pigment

let opposite =
  function | White -> White
           | Blue  -> Gray
           | Gray  -> Blue

type t = Pigment.t array array

let height  = Array.length
let width o = Array.length o.(0)

let get (x, y) o =
  o.(y).(x)

let of_string_array o =
  let width = String.length o.(0)
  and item row x = Pigment.of_char row.[x] in
  let row y = Array.init width (item o.(y)) in
  Array.init (Array.length o) row

let iter f =
  let f = Array.iter f in
  Array.iter f

let iterxy f =
  let f y row =
    let f x c = f (x, y) c in
    Array.iteri f row in
  Array.iteri f

let fold f =
  let f acc row =
    Array.fold_left f acc row in
  Array.fold_left f

let foldxy f acc o =
  let pair a b = (a, b) in
  let f acc (y, row) =
    let f acc (x, c) = f acc (x, y) c in
    row |> Array.mapi pair
        |> Array.fold_left f acc in
  o |> Array.mapi pair
    |> Array.fold_left f acc

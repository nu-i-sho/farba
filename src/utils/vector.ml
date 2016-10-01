type 'a t = { getter : int -> 'a;
              length : int
            }

let make getter length =
  { getter;
    length
  }

let length o = o.length
let item i o = o.getter i

let maybe_item i o =
  if i < (length o) then
    Some (item i o) else
    None

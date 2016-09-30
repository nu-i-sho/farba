type 'a t = { getter : int -> 'a;
              length : int
            }

let make getter length =
  { getter;
    length
  }

let length o = o.length
let get  i o = o.getter i

let try_get i o =
  if i < o.length then
    Some (get i o) else
    None

type 'a t = { getter : int -> 'a;
              length : int
            }

let make getter length =
  { getter;
    length
  }

let length o = o.length
let get  i o = o.getter i

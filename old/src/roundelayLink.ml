include Dlink

let close link =
  let rec go_from' current ~to_limit_of:direction =
    if is_impasse current ~by:direction then current else 
    go_from'
      (get_from current ~by:direction)
      ~to_limit_of:direction
  in
  let open Hand in
  let first = go_from' link ~to_limit_of:Left  in
  let last  = go_from' link ~to_limit_of:Right in
  join first ~with':last ~by:Left

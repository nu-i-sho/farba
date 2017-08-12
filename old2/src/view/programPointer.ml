type t = unit

let make count = () 
let get i _ = 
  let y = (((i / 10) * 4)  
        + (((i mod 10) / 5) * 2) 
        + (((i mod 5) / 4))
        + 1)
        * 54
  in

  let x = ( match i mod 10 with
            |0|8|9 -> 0
            |1|7   -> 1
            |2|6   -> 2
            |3|4|5 -> 3 ) * 54
  in 

  x, y

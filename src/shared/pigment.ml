type t = | Blue
         | Gray
	 | Red

let opposite = 
  function | Blue -> Gray
           | Gray -> Blue
	   | Red  -> Red

let of_hels = 
  function | HelsPigment.Blue -> Blue
           | HelsPigment.Gray -> Gray

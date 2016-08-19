type t = {  run_map : char -> Graphics.color;
           find_map : char -> Graphics.color
         }
       
open Data

let default =
  {  run_map = (function | 'H' -> Color.black
                         | '-' -> Color.white
	                 | ' ' -> Color.empty
                         |  _  -> failwith Fail.invalid_symbol);
    find_map = (function | 'H' -> Color.white
                         | '-' -> Color.black
	                 | ' ' -> Color.empty
                         |  _  -> failwith Fail.invalid_symbol)
  }

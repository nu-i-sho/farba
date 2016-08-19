type t = {  run : char -> Graphics.color;
           find : char -> Graphics.color
         }
       
open Data

let default =
  {  run = (function | 'H' -> Color.black
                     | '-' -> Color.white
	             | ' ' -> Color.empty
                     |  _  -> failwith Fail.invalid_symbol);
    find = (function | 'H' -> Color.white
                     | '-' -> Color.black
	             | ' ' -> Color.empty
                     |  _  -> failwith Fail.invalid_symbol)
  }

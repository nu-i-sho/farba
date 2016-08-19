type t = {     act_map : char -> Graphics.color;
               end_map : char -> Graphics.color;
           declare_map : char -> Graphics.color;
              call_map : char -> Graphics.color
         }
       
open Data
       
let default =
  {     act_map = (function | 'H' -> Color.khaky
                            | '~' -> Color.gray
	                    | '-' -> Color.white
                            | ' ' -> Color.empty
                            |  _  -> failwith Fail.invalid_symbol);
        end_map = (function | 'H' -> Color.blue
                            | '-' -> Color.white
	                    | ' ' -> Color.empty
                            |  _  -> failwith Fail.invalid_symbol);
    declare_map = (function | 'H' -> Color.blue
                            | '-' -> Color.white
	                    | ' ' -> Color.empty
                            |  _  -> failwith Fail.invalid_symbol);
       call_map = (function | 'H' -> Color.gray 
                            | '-' -> Color.white
                            | ' ' -> Color.empty
                            |  _  -> failwith Fail.invalid_symbol)
  }

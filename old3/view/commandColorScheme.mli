type t = private {     act_map : char -> Graphics.color;
                       end_map : char -> Graphics.color;
                   declare_map : char -> Graphics.color;
                      call_map : char -> Graphics.color
                 }

include COLOR_SCHEME.T with type t := t

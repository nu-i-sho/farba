type t = private {  run_map : char -> Graphics.color;
                   find_map : char -> Graphics.color
                 }

include COLOR_SCHEME.T with type t := t

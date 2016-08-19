type t = private {  run : char -> Graphics.color;
                   find : char -> Graphics.color
                 }

include COLOR_SCHEME.T with type t := t

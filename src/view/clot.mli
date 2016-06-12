type t

val coord_of_lines_points : Index.t 
                         -> Side.t 
                         -> t 
                         -> ((int * int) * (int * int))

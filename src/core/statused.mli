type ('a, 'b) t = { status : 'a;
                    value  : 'b
                  }
                
val map : (('a, 'b) t -> 'c) -> ('a, 'b) t -> ('a, 'c) t

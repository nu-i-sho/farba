type ('a, 'b) t = { status : 'a;
                    value  : 'b
                  }
let map f o =
  { o with value = f o }

include Map.Make (struct
                      type t = int
                      let compare = compare
                    end)

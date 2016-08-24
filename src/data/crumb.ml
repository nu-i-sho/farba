module Value = struct
    type 'a t = | Double of 'a * 'a
                | Single of 'a
  end

type 'a t = { value : 'a Value.t;
              index : int
            }

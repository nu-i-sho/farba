module Doubleable = struct
    type 'a t = | Double of 'a * 'a
                | Single of 'a
  end

module Tripleable = struct
    type 'a t = | Triple of 'a * 'a * 'a
                | Double of 'a * 'a
                | Single of 'a
  end

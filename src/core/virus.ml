module Farba = struct
  type t = Yellow | Orange
  end

module Foreign = struct
  type t = Red | Pink
  end

type t =
  | Farba   of Farba.t
  | Foreign of Foreign.t

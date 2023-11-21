module Alive = struct
  type t =
    [ `FinalB
    | `FinalG
    | `Trans
    ]
  end

module Dead = struct
  type t =
    [ `Closed
    ]
  end

type t =
  [ Alive.t
  | Dead.t
  ]

let of_alive x = (x : Alive.t :> t)
let of_dead  x = (x : Dead.t  :> t)

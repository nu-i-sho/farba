module Alive = struct
  type t =
    [ `FinalB
    | `FinalG
    | `Trans
    ]
  end

type t =
  [ Alive.t
  | `Closed
  ]


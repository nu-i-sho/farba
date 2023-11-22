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

let to_alive_opt = function
  | (`FinalB as x)
  | (`FinalG as x)
  | (`Trans  as x) -> Some x
  |  `Closed       -> None

let to_dead_opt = function
  |  `FinalB
  |  `FinalG
  |  `Trans        -> None
  | (`Closed as x) -> Some x

let is_alive x = Option.is_some (to_alive_opt x) 
let is_dead  x = Option.is_some (to_dead_opt x)

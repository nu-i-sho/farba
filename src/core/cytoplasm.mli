type alive_t :=
  [ `FinalB
  | `FinalG
  | `Trans
  ]

type dead_t :=
  [ `Closed
  ]

type t =
  [ alive_t
  | dead_t
  ]

include DEADLY.T
   with type t := t
    and type Alive.t = alive_t
    and type Dead.t = dead_t

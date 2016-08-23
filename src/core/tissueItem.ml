open Data
type t = | Cytoplasm of Pigment.t
         | Active of Cell.t
         | Static of Cell.t
         | Clot of Side.t
         | Outed of Nucleus.t
         | Out

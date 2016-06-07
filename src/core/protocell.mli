type t = private {   pigment : Pigment.t;
                        gaze : HexagonSide.t;
                   cytoplasm : Pigment.t option;
                 }

val first : t
val kind_of : t -> CellKind.t
val turn : HandSide.t -> t -> t
val to_clot : t -> t
val inject : HelsPigment.t -> t -> t
val replicate : Relationship.t -> t -> t

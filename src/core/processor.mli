module Make : functor (Tissue : module type of Tissue) ->
              functor   (Tape : module type of Tape) ->
              sig type t
                  val make : Tissue.t -> Tissue.Coord.t -> Tape.t -> t
                  val step : t -> t option
                  end

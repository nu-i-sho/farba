include Api.Make (OProcessor)

module EventsOf = struct
  module Cursor =
    ReObservable.Make (OProcessor.EventsOf.Cursor)
      ( struct type nonrec t = t
               let pack processor o = make processor (level_id o) (session o)
               let unpack = processor
               end
      )
  end

include Processor.Make (OCursor)

module EventsOf = struct
  module Cursor =
    ReObservable.Make (OCursor)
      ( struct type nonrec t = t
               let pack cursor o = make cursor (tape o)
               let unpack = cursor
               end
      )
  end

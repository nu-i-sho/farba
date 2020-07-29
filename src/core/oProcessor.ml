include Processor.Make (OCursor)

module EventsOf = struct
  module Cursor = struct
    module OBSERVER = OCursor.OBSERVER
                    
    type event = OCursor.event
    type 'a observer = 'a OCursor.observer
    type 'a subscription = 'a OCursor.subscription

    let o' cursor o =
      make cursor (tape o)
                         
    let subscribe obs obs_init o =
      let subscription, cursor =
        OCursor.subscribe obs obs_init (cursor o) in
      subscription, (o' cursor o)
      
    let unsubscribe subscription o =
      let obs, cursor =
        OCursor.unsubscribe subscription (cursor o) in
      obs, (o' cursor o)
    end
  end

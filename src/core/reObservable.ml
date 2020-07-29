module Make (Observable : OBSERV.ABLE.S)
             (Container : PACK.MAKE (Observable).S) = struct

  module OBSERVER = Observable.OBSERVER

  type t = Container.t
  type event = Observable.event
  type 'a observer = 'a Observable.observer
  type 'a subscription = 'a Observable.subscription
                       
  let subscribe observer observer_init o =
    let observable = Container.unpack o in 
    let subscription, observable =
        Observable.subscribe observer observer_init observable in
      subscription, (Container.pack observable o)
      
  let unsubscribe subscription o =
    let observable = Container.unpack o in 
    let observer, observable =
      Observable.unsubscribe subscription observable in
      observer, (Container.pack observable o)
  end
                   

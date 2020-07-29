module ER (* OBSERV.ER *) = struct
  module type S = sig
    type event
    type t
          
    val send : event -> t -> t
    end
  end


module ABLE (* OBSERV.ABLE *) = struct
  module type S = sig
    type event
       
    module OBSERVER : sig
      module type S = ER.S (* OBSERV.ER.S *)
        with type event = event
      end
         
    type 'a observer =
      ( module OBSERVER.S
          with type t = 'a
      )
      
    type 'a subscription
    type t
                                 
    val subscribe   : 'a observer -> 'a -> t -> 'a subscription * t
    val unsubscribe : 'a subscription -> t -> 'a * t
    end

  module COPY (Observable : S) = struct
    module type S = S
      with type event = Observable.event
       and type 'a observer = 'a Observable.observer
       and type 'a subscription = 'a Observable.subscription
       and module OBSERVER = Observable.OBSERVER
    end
  end

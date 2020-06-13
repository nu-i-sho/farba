module Make (Event : sig type t end) = struct

  type event = Event.t
  type _ registry = ..
   
  module OBSERVER = struct
    module type S = OBSERV.ER.S with type event = event    
    module REGISTERED = struct
      module type S = sig
        include S
        type _ registry += Id : t registry
          
        val id : int
        val state : t
        end
      end
    end 

  type 'a observer =
    ( module OBSERVER.S
        with type t = 'a
    )
                  
  type 'a subscription =
    ( module OBSERVER.REGISTERED.S
        with type t = 'a
    ) 
    
  let register (type a)
         ((module Observer) : a observer) id state
      : a subscription =
      ( module struct
          include Observer
          type _ registry += Id : t registry
        
          let id = id
          let state = state 
          end
      ) 
  
    type e = Pack : 'a subscription -> e
    type t = 
      {   next_id : int;
        observers : e list
      } 
    
    let empty = 
      {   next_id = 0;
        observers = []
      }

    let subscribe (type a) (observer : a observer) state o =
      let subscription = register observer o.next_id state in
      subscription,
      {   next_id = succ o.next_id;
        observers = (Pack subscription) :: o.observers
      }
    
    let unsubscribe (type a) ((module X) : a subscription) o = 
      let rec unsubscribe: (e list) -> a * (e list) = function 
        | (Pack (module H)) :: t when X.id = H.id ->
            ( match X.Id with
              | H.Id -> H.state, t
              | _    -> raise Not_found
            )
        | h :: t ->
            let state, t = unsubscribe t in
            state, h :: t 
        | [] -> raise Not_found in
      let state, observers =
        unsubscribe o.observers in
      state, { o with observers }
  
    let send event o = 
      let rec send = function
        | (Pack (module H)) :: t ->
            (Pack (module struct
                     include H
                     let state = H.send event H.state
                     end)
            ) :: (send t)
        | [] -> [] in
      { o with 
        observers = send o.observers
      }
  end 

module Event = struct
  type t =
    | NucleusAdded   of HexCoord.t * Nucleus.t
    | NucleusRemoved of HexCoord.t * Nucleus.t
    | NucleusChanged of HexCoord.t * Nucleus.t * Nucleus.t
    | CytoplasmAdded of HexCoord.t * Pigment.t
    | MindAdded      of HexCoord.t * Nucleus.t
    | MindRemoved    of HexCoord.t * Nucleus.t
    | ClotAdded      of HexCoord.t
    | ClotRemoved    of HexCoord.t      
  end
                      
module OBSERVER = struct
  module type S = OBSERVER.S with type event = Event.t
  module INTERNAL = struct
    module type S = sig
      include S
      val current : t
      end
    end
  end

module Make (Base : module type of Tissue) = struct
  module OBSERVER = OBSERVER
  module Event = Event
  module Subscription = struct
    type t = int
    end
                    
  module IMap = Map.Make (Int)
  
  type t =
    { next_obs_id : Subscription.t;
        observers : (module OBSERVER.INTERNAL.S) list;
             base : Base.t
    }
      
  let empty =
    { next_obs_id = 0;
        observers = IMap.empty;
             base = Base.empty;
    }

  let subscribe (type t) (module Obs : OBSERVER.S with type t = t) init o =
    o.next_obs_id,
    { o with
      next_obs_id = succ o.next_obs_id;
        observers = IMap.add o.next_obs_id
                      (module struct
                         include Obs
                         let current = init
                         end : OBSERVER.INTERNAL.S
                      ) o.observers
    }

  let subscribe_f f =
    subscribe (module struct
                 type event = Event.t
                 type t = unit 
                 let send event () = f event
                 end : OBSERVER.S
               ) ()
    
  let send event observers =
    let send (module Obs : OBSERVER.INTERNAL.S) = 
      (module struct
         include Obs
         let current = send event current
         end : OBSERVER.INTERNAL.S
      ) in
    IMap.map send observers

  let unsubscribe subscription o =
    let observer  = o.observers |> IMap.find   subscription 
    and observers = o.observers |> IMap.remove subscription in
    observer, { o with observers }
 
  let is_in         i o = o.base |> Base.is_in i
  let is_out_of     i o = o.base |> Base.is_out_of i
  let has_clot        o = o.base |> Base.has_clot
  let clot            o = o.base |> Base.clot
  let clot_opt        o = o.base |> Base.clot_opt
  let cytoplasm     i o = o.base |> Base.cytoplasm i
  let cytoplasm_opt i o = o.base |> Base.cytoplasm_opt i
  let cytoplasms      o = o.base |> Base.cytoplasms
  let nucleus       i o = o.base |> Base.nucleus i
  let nucleus_opt   i o = o.base |> Base.nucleus_opt i
  let nucleuses       o = o.base |> Base.nucleuses

  let set_nucleus i x o =
    let prev =  o.base |> Base.nucleus_opt i
    and base =  o.base |> Base.set_nucleus i x in 
    let current = base |> Base.nucleus i
    and event = match prev with
      | Some prev -> Event.NucleusChanged (i, prev, current)
      | None      -> Event.NucleusAdded   (i,       current) in        
    let observers =
      o.observers |> send event in
    { o with
      observers;
      base
    }

  let remove_nucleus i o =
    let prev = o.base |> Base.nucleus i
    and base = o.base |> Base.remove_nucleus i in
    let event = Event.NucleusRemoved (i, prev) in
    let observers =
      o.observers |> send event in
    { o with
      observers;
      base
    }
    
  end

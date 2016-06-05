module Data = struct
    module Make (Cell : T'.T) = struct

        module State = struct
            type t = {  body : Protocell.t;
                       index : Set.Index.t
                     }
          end

        module ReplicationResult = struct
            type t = | SelfClotted of Cell.t'
                     | Replicated of Cell.t'
                     | ReplicatedOut
         end
     end
  end

module type T = sig
    type t

    include module type of Data.Make(struct type t' = t end)
    val state_of : t -> State.t

    val turn : HandSide.t -> t -> t

    val replicate : relationship : Relationship.t 
                 -> donor : t
                 -> ReplicationResult.t
  end

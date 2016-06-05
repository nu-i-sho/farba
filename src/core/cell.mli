type t

type start_result_t =
  | ImpossibleToStartFromNonEmptyHexagon
  | Started of t

type replication_result_t = 
  | ReplicatedToOutOfWorld
  | SelfClotted of t
  | Replicated of t
  

val start : level:Set.t 
         -> start:Set.Index.t 
         -> start_result_t

val turn : HandSide.t -> t -> t

val replicate : relationship:Relationship.t 
             -> donor:t
             -> replication_result_t

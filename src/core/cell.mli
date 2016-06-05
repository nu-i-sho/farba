type t

type rep_res_t = private | SelfClotted of t
			 | Replicated of t
			 | ReplicatedOut
include CELL.T 
	with type t := t 
         and type rep_res_t := rep_res_t

val start : level:Set.t 
         -> start:Set.Index.t 
         -> t option

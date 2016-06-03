type t = | Cytoplazm of HelsPigment.t
         | Celluar of Celluar.t

val replicate : Relationship.t 
	     -> donor:Celluar.t
	     -> acceptor:t option
	     -> (t * t)


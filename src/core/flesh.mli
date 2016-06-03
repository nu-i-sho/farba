type t = | Procaryotic of Procaryote.t
         | Eucaryotic of Eucaryote.t

val replicate : Relationship.t 
	     -> donor:Eucaryote.t
	     -> acceptor:t option
	     -> (t * t)


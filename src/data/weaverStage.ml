type pass_t = | Dummy
              | Success
              
type move_t = | Dummy
              | Success
	      | ToClot
	      | Out
              
type t = | Created
         | Turned
         | Passed of pass_t
         | Moved of move_t 
         | Replicated of move_t
         
         

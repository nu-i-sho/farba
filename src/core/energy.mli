module Make : functor (Num : SEQUENTIAL.T) -> sig

  module Call   : sig type t = private Num.t end
  module Wait   : sig type t = private Num.t end                   
  module Find   : sig type t = private Num.t end                   
  module Open   : sig type t = private Num.t end
  module Close  : sig type t = private Num.t end
  module Return : sig type t = private Num.t end
       
                      
  val origin : Call.t
  val find   : Call.t -> Wait.t * Find.t
  val open'  : Find.t -> Open.t * Call.t
  val close  : Call.t -> Close.t
  val return : Open.t -> Close.t -> Return.t option
  val done'  : Wait.t -> Return.t -> Call.t option

end

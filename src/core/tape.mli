module Make : functor (Num : SEQUENTIAL.T) -> sig

  type 'cmd t

  val step : 'cmd t -> 'cmd * int * ('cmd t)
     
  end

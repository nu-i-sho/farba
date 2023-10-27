module Make : functor (Num : SEQUENTIAL.T) -> sig

  type 'cmd t
                   
  type 'cmd tick = private
    { command : 'cmd option;
            o : 'cmd t
    }

  type 'cmd step = private
    {     command : 'cmd;
      ticks_count : int;
                o : 'cmd t
    }
    
  type error = private
    | Nothing_to_do_with_empty_program
    | Procedure_not_found of Num.t
     
  val tick : 'cmd t -> ('cmd tick, error) result
  val step : 'cmd t -> ('cmd step, error) result
     
  end

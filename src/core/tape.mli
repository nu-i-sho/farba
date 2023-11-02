module Make : functor (Num : SEQUENTIAL.T) -> sig

  type 'cmd t

  type error = private
    | Nothing_to_do_with_empty_program
    | Procedure_not_found of Num.t

  val load : ('cmd, Num.t, Num.t) Statement.t list -> 'cmd t
                           
  module Tick : sig
    type 'cmd tape := 'cmd t
    type 'cmd t

    val command : 'cmd t -> 'cmd option
    val tape    : 'cmd t -> 'cmd tape

    val start   : 'cmd tape -> ('cmd t, error) result
    val succ    : 'cmd t    -> ('cmd t, error) result
    end

  module Step : sig
    type 'cmd tape := 'cmd t
    type 'cmd t

    val command    : 'cmd t -> 'cmd
    val tiks_count : 'cmd t -> int 
    val tape       : 'cmd t -> 'cmd tape 

    val start      : 'cmd tape   -> ('cmd t, error) result
    val adjust     : 'cmd Tick.t -> ('cmd t, error) result
    val succ       : 'cmd t      -> ('cmd t, error) result
    val tick       : 'cmd t      -> ('cmd Tick.t, error) result
    end
       
  end

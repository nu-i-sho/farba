module type S = sig
  module Current : sig
    module Stage : sig
      type t =
        | Call of Energy.Call.t
        | Back of Energy.Back.t
        | Find of Energy.Find.t
    end

    module Link : sig          
      type t =
        | Start
        | Cell of (int * Cell.t) 
        | End
    end

    type t = Stage.t * Link.t    
  end

  type t
     
  val make   : Statement.t list -> t
  val source : t -> Statement.t list
  val cells  : t -> Cell.t list
  val cellsi : t -> (int * Cell.t) list
  val cell   : int -> t -> Cell.t
  val insert : int -> Statement.t -> t -> t
  val remove : int -> t -> t
    
  val current  : t -> Current.t
  val pop_prev :
end

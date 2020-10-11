type t

module Coord : sig
  type t = private int * int

  val zero    : t
  val none    : t
  val is_none : t -> bool
  val move    : Side.t -> t -> t
  module Map  : Map.S with type key = t
       
  end

val cytoplasm     : Coord.t -> t -> Pigment.t
val cytoplasm_opt : Coord.t -> t -> Pigment.t option
val nucleus       : Coord.t -> t -> Nucleus.t
val nucleus_opt   : Coord.t -> t -> Nucleus.t option
val cursor        : t -> Coord.t
val clot          : t -> Coord.t

module Constructor : sig
  module Command : sig
    type t =
      | Move of Side.t
      | Add_cytoplasm of Pigment.t
      | Add_nucleus of Nucleus.t
      | Set_cursor
      | Set_clot
    end

  type tissue := t
  type t

  val empty   : t
  val perform : Command.t -> t -> t
  val product : t -> tissue
    
  end

module Destructor : sig
  type tissue := t
  type t

  val make : tissue -> t
  val next : t -> (Constructor.Command.t option) * t 
  end
     
module Cursor : sig   
  module Command : sig
    type t =
      | Turn of Hand.t
      | Move of Nature.t
      | Replicate of Gene.t
    end
       
  type tissue := t
  type t

  val make             : tissue -> t
  val is_out_of_tissue : t -> bool
  val is_clotted       : t -> bool
  val perform          : Command.t -> t -> t
  val tissue           : t -> tissue

  exception Clotted
  exception Out_of_tissue
         
  end

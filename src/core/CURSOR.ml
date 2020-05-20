module type S = sig
  type tissue
  type coord
  type t
   
  val make     : coord -> tissue -> t
  val perform  : Command.t -> t -> t
  val tissue   : t -> tissue
  val position : t -> coord
    
  exception Clotted
  exception Out_of_tissue
  
  val is_out_of_tissue : t -> bool
  val is_clotted       : t -> bool

  end

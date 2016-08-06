module type T = sig
  type t
     
  val put_none : t -> t
  val put : string -> t -> t
  val put_all : string list -> t -> t
  val put_change_dir_to : string -> t -> t
  val put_remove : string -> t -> t
  val put_make : string -> t -> t
  val finish : t -> unit
    
end

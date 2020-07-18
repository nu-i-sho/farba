type t

module File : sig
  module Error : sig
    module OpenNew  : sig
      type t = [ `LEVEL_IS_MISSING
               | `LEVEL_IS_UNAILABLE
               ]
      end

    module Access : sig
      type t = [ `PERMISSION_DENIED
               ]
      end
         
    module Restore : sig
      type t = [  Access.t
               | `BACKUP_NOT_FOUND
               | `BACKUP_IS_CORRUPTED
               ]
      end
       
    module Save : sig
      type t = [  Access.t
               | `NAME_IS_EMPTY
               ]
      end

    module SaveAs : sig
      type t = [  Save.t
               | `FILE_ALREADY_EXIST
               ]
      end
       
    type t =
      [ OpenNew.t
      | Access.t
      | Restore.t
      | Save.t
      | SaveAs.t
      ]
    end
   
  val open_new   : int -> (t, Error.OpenNew.t) result    
  val restore    : int -> string -> (t, Error.Restore.t) result
  val save       : t -> (t, Error.Save.t) result
  val save_as    : string -> t -> (t, Error.SaveAs.t) result
  val save_force : string -> t -> (t, Error.Save.t) result
  end

module Debug : sig
  val step : t -> t option
  end

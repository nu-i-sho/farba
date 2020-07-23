type t

module File : sig
  module Error : sig
    module OpenNew  : sig
      type t = [ `Level_is_missing
               | `Level_is_unavailable
               ]
      end

    module Access : sig
      type t = [ `Permission_denied
               ]
      end
         
    module Restore : sig
      type t = [  Access.t
               | `Backup_not_found
               | `Backup_is_corrupted
               ]
      end
       
    module Save : sig
      type t = [  Access.t
               | `Name_is_empty
               ]
      end

    module SaveAs : sig
      type t = [  Save.t
               | `File_already_exists
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

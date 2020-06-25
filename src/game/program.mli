type t

module Error : sig
  module OpenNew : sig
    type t =
      private | Level_is_missing
              | Level_is_closed
    end

  module Restore : sig
    type t =
      private | Backup_not_found
              | Backup_is_corrupted
    end
       
  module Save : sig
    type t =
      private | Name_is_empty
    end

  module SaveAs : sig
    type t =
      private | Name_is_empty
              | File_exists
    end
  end
   
val open_new   : int -> (t, Error.OpenNew.t) result    
val restore    : int -> string -> (t, Error.Restore.t) result
val save       : t -> (t, Error.Save.t) result
val save_as    : string -> t -> (t, Error.SaveAs.t) result
val save_force : string -> t -> (t, Error.Save.t) result

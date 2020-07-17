type t

module Error : sig
  module OpenNew  : sig
    type t = [ `LEVEL_IS_MISSING
             | `LEVEL_IS_UNAILABLE
             ]
    end

  module AccessFile : sig
    type t = [ `PERMISSION_DENIED
             ]
    end
       
  module Restore : sig
    type t = [  AccessFile.t
             | `BACKUP_NOT_FOUND
             | `BACKUP_IS_CORRUPTED
             ]
    end
       
  module Save : sig
    type t = [  AccessFile.t
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
    | Restore.t
    | AccessFile.t
    | Save.t
    | SaveAs.t
    ]
  end
   
val open_new   : int -> (t, Error.OpenNew.t) result    
val restore    : int -> string -> (t, Error.Restore.t) result
val save       : t -> (t, Error.Save.t) result
val save_as    : string -> t -> (t, Error.SaveAs.t) result
val save_force : string -> t -> (t, Error.Save.t) result

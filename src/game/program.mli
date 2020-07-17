type t

module Error : sig
  module OpenNew  : sig
    type t = [ `LEVEL_IS_MISSING
             | `LEVEL_IS_UNAILABLE
             ]
    end

  module Restore : sig
    type t = [ `BACKUP_NOT_FOUND
             | `BACKUP_IS_CORRUPTED
             ]
    end
       
  module Save : sig
    type t = [ `NAME_IS_EMPTY
             | `PERMISSION_DENIED
             ]
          
    module As : sig
      type nonrec t =
        [ t
        | `FILE_ALREADY_EXIST
        ]
      end
    end
       
  type t =
    [ OpenNew.t
    | Restore.t
    | Save.t
    | Save.As.t
    ]
  end
   
val open_new   : int -> (t, Error.OpenNew.t) result    
val restore    : int -> string -> (t, Error.Restore.t) result
val save       : t -> (t, Error.Save.t) result
val save_as    : string -> t -> (t, Error.Save.As.t) result
val save_force : string -> t -> (t, Error.Save.t) result

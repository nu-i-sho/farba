module Settings : sig type t end
module Runtime  : sig type t end

type settings := [ `Settings of Settings.t ]
type runtime  := [ `Runtime  of Runtime.t ]
type any      := [ settings | runtime ]

val empty : settings
  
module File : sig

  module OpenNew : sig
    type error =
      [ `Level_is_missing
      | `Level_is_unavailable
      ]
    and result =
      [ `Error of error
      |  runtime
      ]
      
    val perform : int -> any -> result
    end

  module Access : sig
    type error =
      [ `Permission_denied
      ]
    end

  module Restore : sig
    type error =
      [  Access.error
      | `Backup_not_found
      | `Backup_is_corrupted
      ]
    and result =
      [ `Error of error
      |  runtime 
      ]

    val perform : int -> string -> any -> result
    end

  module Close : sig
    type result = settings      
    val perform : runtime -> result
    end

  module Save : sig
    type error =
      [  Access.error
      | `Name_is_empty
      ]
    and result =
      [ `Error of error
      |  runtime
      ]
      
    val perform : runtime -> result
    end

  module SaveAs : sig
    type error =
      [  Save.error
      | `Backup_already_exists
      ]
    and result =
      [ `Error of error
      |  runtime
      ]
               
    val perform : string -> runtime -> result
    end

  module SaveAsForce : sig
    type error = Save.error
    and result =
      [ `Error of error
      |  runtime
      ]
               
    val perform : string -> runtime -> result
    end
  end
     
(*module Debug : sig
  val step : runtime -> runtime option
  end
 *)

module EventsOf : sig
  module Tissue : sig
    
    module Constructor :
      OBSERV.ABLE.COPY(Subject.Make(OTissue.Constructor.Event)).S
        with type t = any
         
    module Cursor :
      OBSERV.ABLE.COPY(Subject.Make(OTissue.Cursor.Event)).S
        with type t = any

    module Destructor :
      OBSERV.ABLE.COPY(Subject.Make(OTissue.Destructor.Event)).S
        with type t = any
    end
  end


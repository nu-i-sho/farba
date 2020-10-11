type t
   
val make        : OTissue.Cursor.t -> Tape.t -> t
val with_cursor : OTissue.Cursor.t -> t -> t
val with_tape   : Tape.t -> t -> t
val cursor      : t -> OTissue.Cursor.t
val tape        : t -> Tape.t
val step        : t -> t option 

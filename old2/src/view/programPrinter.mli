module Make (Canvas : CANVAS.T)
        (CommandImg : IMG.COMMAND.T)
           (Pointer : PROGRAM_POINTER.T) : sig

    val print : Program.t -> Pointer.t -> unit

  end

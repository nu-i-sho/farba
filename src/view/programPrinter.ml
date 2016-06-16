module Make     (Canvas : CANVAS.T)
            (CommandImg : IMG.COMMAND.T)
               (Pointer : PROGRAM_POINTER.T) = struct

    let print program =
      let length  = Program.length program in
      let pointer = Pointer.make length in
      for i = 0 to length do
	Canvas.draw_image (program |> Program.get i
                                   |> CommandImg.get)
			  (pointer |> Pointer.get i)
      done

end

module Make     (Canvas : CANVAS.T)
            (CommandImg : IMG.COMMAND.T)
               (Pointer : PROGRAM_POINTER.T) = struct

    let print program pointer =
      for i = 0 to Program.length program do
	Canvas.draw_image (program |> Program.get i
                                   |> CommandImg.get)
			  (pointer |> Pointer.get i)
      done

end

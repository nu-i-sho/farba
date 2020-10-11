let get_tissue_build () =
  let module Cmd = Tissue.Constructor.Command in
  let n = Nucleus.make in
  
  [ Cmd.Add_cytoplasm Pigment.White;
    Cmd.Move          Side.Down;
    Cmd.Add_cytoplasm Pigment.Blue;
    Cmd.Add_nucleus(n Pigment.Blue Side.LeftUp);
    Cmd.Set_cursor; 
    Cmd.Move          Side.Down;
    Cmd.Add_cytoplasm Pigment.White
  ]  

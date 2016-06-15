type t = int array array

module Color = struct

    let blue  = 0x4682B4
    let gray  = 0x808080
    let khaky = 0xF0E68C
    let white = 0xF8F8FF
    let empty = -1 
  
  end

let act_of_char =
  function | 'X' -> Color.gray
           | 'O' -> Color.khaky
	   | '-' -> Color.white
           | ' ' -> Color.empty

let call_of_char =
  function | 'H' -> Color.gray 
           | '-' -> Color.white
           | ' ' -> Color.empty           

let declare_of_char = 
  function | 'H' -> Color.blue
	   | '-' -> Color.white
	   | ' ' -> Color.empty

let to_img parse strs = 
  let strs = Lazy.force strs in
  let width = Array.length strs in
  let height = String.length strs.(0) in  
  let parse y x = parse strs.(y).[x] in
  let parse_row y = Array.init height (parse y) in
  Array.init width parse_row

let declare_OOOOOO = 
  lazy( Img.Command.OOOOOO.prototype
	|> to_img declare_of_char
      )

let declare_OOOOO = 
  lazy( Img.Command.OOOOO.prototype
	|> to_img declare_of_char
      )

let declare_OOOO = 
  lazy( Img.Command.OOOO.prototype
	|> to_img declare_of_char
      )

let declare_OOO = 
  lazy( Img.Command.OOO.prototype
	|> to_img declare_of_char
      )

let declare_OO = 
  lazy( Img.Command.OO.prototype
	|> to_img declare_of_char
      )

let declare_O = 
  lazy( Img.Command.O.prototype
	|> to_img declare_of_char
      )

let call_OOOOOO = 
  lazy( Img.Command.OOOOOO.prototype
	|> to_img call_of_char
      )

let call_OOOOO = 
  lazy( Img.Command.OOOOO.prototype
	|> to_img call_of_char
      )

let call_OOOO = 
  lazy( Img.Command.OOOO.prototype
	|> to_img call_of_char
      )

let call_OOO = 
  lazy ( Img.Command.OOO.prototype
	 |> to_img call_of_char
       )

let call_OO = 
  lazy( Img.Command.OO.prototype
	|> to_img call_of_char
      )

let call_O = 
  lazy( Img.Command.O.prototype
	|> to_img call_of_char
      )

let turn_left = 
  lazy( Img.Command.TurnLeft.prototype 
	|> to_img act_of_char
      )

let turn_right = 
  lazy( Img.Command.TurnRight.prototype 
	|> to_img act_of_char
      )

let repl_direct = 
  lazy( Img.Command.ReplicateDirect.prototype 
	|> to_img act_of_char
      )

let repl_inverse = 
  lazy( Img.Command.ReplicateInverse.prototype 
	|> to_img act_of_char
      )

let end' = 
  lazy( Img.Command.End.prototype
        |> to_img declare_of_char
      )

let call dots = 
  let open DotsOfDice in
  match dots with
  | OOOOOO -> call_OOOOOO
  | OOOOO -> call_OOOOO
  | OOOO -> call_OOOO
  | OOO -> call_OOO
  | OO -> call_OO
  | O -> call_O 

let declare dots = 
  let open DotsOfDice in
  match dots with
  | OOOOOO -> declare_OOOOOO
  | OOOOO -> declare_OOOOO
  | OOOO -> declare_OOOO
  | OOO -> declare_OOO
  | OO -> declare_OO
  | O -> declare_O 


let get command = 
  let open Hand in
  let open Command in
  let open Relationship in
  Lazy.force ( match command with
	       | Turn Left         -> turn_left
               | Turn Right        -> turn_right
	       | Replicate Direct  -> repl_direct
	       | Replicate Inverse -> repl_inverse
	       | Call dots         -> call dots
	       | Declare dots      -> declare dots
	       | End               -> end'
	     )

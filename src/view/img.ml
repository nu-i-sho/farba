open IMG_PROTOTYPE

module Dots = DotsOfDice
module Map = Map.Make(Dots)

type t = IMG.t

module Color = struct

    let blue  = 0x4682B4
    let gray  = 0x808080
    let khaky = 0xF0E68C
    let white = 0xF8F8FF
    let empty = -1 
  
  end

let to_img parse prototype =
  lazy ( let module Prototype = (val prototype : T) in
         let strs = Lazy.force (Prototype.matrix) in
         let width = Array.length strs in
         let height = String.length strs.(0) in  
         let parse y x = parse strs.(y).[x] in
         let parse_row y = Array.init height (parse y) in
         Array.init width parse_row
       )

module MakeMapper (ProtoImg : DOTS_OF_DICE.T) = struct
   
    let map parse = 
      let extract_module =
	function | Dots.OOOOOO -> (module ProtoImg.OOOOOO : T)
                 | Dots.OOOOO -> (module ProtoImg.OOOOO : T)
                 | Dots.OOOO -> (module ProtoImg.OOOO : T)
                 | Dots.OOO -> (module ProtoImg.OOO : T)
		 | Dots.OO -> (module ProtoImg.OO : T)
		 | Dots.O -> (module ProtoImg.O : T)
      in

      let map = Map.empty in
      let add m (k, v) = Map.add k v m in
      Dots.all |> List.map extract_module
               |> List.map (to_img parse)
               |> List.combine Dots.all
               |> List.fold_left add map 
  end

module Breadcrumbs = struct
    module Make (ProtoImg : DOTS_OF_DICE.T) = struct
	
	let crumb_of_char = 
	  function | 'H' -> 0
                   | '-' -> Color.white
	           | ' ' -> Color.empty

	module Mapper = MakeMapper(ProtoImg)
	let crumbs = Mapper.map crumb_of_char
	let get dots = crumbs |> Map.find dots
                              |> Lazy.force
      end                

    module Default = Make(ImgPrototype.X20.DotsOfDice)
  end
	 
module Command = struct
    module Make (ProtoImg : COMMAND.T) = struct

	let act_of_char = 
	  function | 'H' -> Color.khaky
                   | '~' -> Color.gray
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

	module Mapper = MakeMapper(ProtoImg.DotsOfDice)
 
	let declare = Mapper.map declare_of_char
	let call = Mapper.map call_of_char

	let turnl, turnr, replinv, repldir = 0, 1, 2, 3
	let acts = 
	  [| (module ProtoImg.Act.TurnLeft         : T);
	     (module ProtoImg.Act.TurnRight        : T);
	     (module ProtoImg.Act.ReplicateDirect  : T);
	     (module ProtoImg.Act.ReplicateInverse : T)
          |]
	  |> Array.map (to_img act_of_char) 
		       
	let end' = to_img declare_of_char 
			  (module ProtoImg.End : T) 

	let get command =
	  let open Hand in
	  let open Command in
	  let open Relationship in
	  ( match command with
	    | Turn Left         -> acts.(turnl)
	    | Turn Right        -> acts.(turnr)
	    | Replicate Direct  -> acts.(repldir)
	    | Replicate Inverse -> acts.(replinv)
	    | Call dots         -> Map.find dots call
	    | Declare dots      -> Map.find dots declare
	    | End               -> end'
	  ) |> Lazy.force
      end

    module Default = Make (ImgPrototype.X54)
  end

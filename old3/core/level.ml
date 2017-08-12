open Data
open Tools
   
type t = { active : int * int;
           height : int;
            width : int;
            flora : Pigment.t IntPointMap.t;
            fauna : Nucleus.t IntPointMap.t;
             path : LevelPath.t
	 }

let active o = o.active
let height o = o.height
let width  o = o.width
let flora  o = o.flora
let fauna  o = o.fauna
let path   o = o.path
                 
module Loader = struct
    module TREE = CONTRACTS.LEVELS_SOURCE_TREE
    module Make (LevelsSourceTree : TREE.ROOT.T) = struct
      
        module NodeMap   = DotsOfDiceNodeMap
        module Root      = NodeMap.Make (TREE.BRANCH)
        module Branch    = NodeMap.Make (TREE.BRANCHLET)
        module Branchlet = NodeMap.Make (TREE.LEAF)

        let parse_cytoplasm acc i =
          IntPointMap.(
            function | '*' -> acc
                     | 'O' -> acc |> add i Pigment.Gray
	             | '0' -> acc |> add i Pigment.Blue
                     | ' ' -> acc |> add i Pigment.White
	             |  _  -> failwith Fail.invalid_symbol
          )
          
        let parse_nucleus acc i = 
          let add_nucleus pigment gaze = 
	    IntPointMap.add i Nucleus.({ pigment; gaze }) acc
	  in
	     
	  let add_gray = add_nucleus Pigment.Gray
	  and add_blue = add_nucleus Pigment.Blue in

	  function | '*'
                   | ' ' -> acc

	           | 'a' -> add Gray Up
                   | 'b' -> add Gray RightUp
                   | 'c' -> add Gray RightDown
                   | 'd' -> add_gray Side.Down
                   | 'e' -> add_gray Side.LeftDown
                   | 'f' -> add_gray Side.LeftUp

		   | 'A' -> add_blue Side.Up
                   | 'B' -> add_blue Side.RightUp
                   | 'C' -> add_blue Side.RightDown
                   | 'D' -> add_blue Side.Down
                   | 'E' -> add_blue Side.LeftDown
                   | 'F' -> add_blue Side.LeftUp
                          
                   |  _  -> failwith Fail.invalid_symbol

        let load path =
          let root = (module LevelsSourceTree : TREE.ROOT.T) in
          let open LevelPath in
          let module Src = 
	    (val (root |> Root.get path.branch
                       |> Branch.get path.branchlet
                       |> Branchlet.get path.leaf) : TREE.LEAF.T) in

          let empty = IntPointMap.empty
          and flora = Lazy.force Src.flora
          and index = 
	    function | Some i -> i
                     | None   -> failwith Fail.invalid_source in

          { active = Src.active |> Lazy.force
                                |> Matrix.of_string_list
	                        |> Matrix.index ((=)'X')
                                |> index;

	     fauna = Src.fauna |> Lazy.force
                               |> Matrix.of_string_list
                               |> Matrix.foldi parse_nucleus empty;

             flora = flora |> Matrix.of_string_list
                           |> Matrix.foldi parse_cytoplasm empty;

	    height = flora |> List.length;
             width = flora |> List.hd
                           |> String.length;
              path
          }
      end
  end

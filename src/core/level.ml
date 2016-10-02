open Data.Shared
open Data.Tissue
open Shared.Fail
open Utils
   
type t = { active : int * int;
           height : int;
            width : int;
            flora : cytoplasm IntPointMap.t;
            fauna : nucleus IntPointMap.t;
             path : level_path
	 }

let active o = o.active
let height o = o.height
let width  o = o.width
let flora  o = o.flora
let fauna  o = o.fauna
let path   o = o.path

module Loader = struct
    module TREE = LEVELS.SOURCE_TREE
    module Make (LevelsSourceTree : TREE.ROOT.T) = struct
      
        module NodeMap   = Shared.DotsOfDiceNodeMap
        module Root      = NodeMap.Make (TREE.BRANCH)
        module Branch    = NodeMap.Make (TREE.BRANCHLET)
        module Branchlet = NodeMap.Make (TREE.LEAF)

        let parse_cytoplasm acc i =
          function | ' ' -> acc
                   | 'O' -> acc |> IntPointMap.add i Gray
	           | '0' -> acc |> IntPointMap.add i Blue
                   | '.' -> acc |> IntPointMap.add i White
	           |  _  -> raise (Inlegal_case "invalid symbol")
      
        let parse_nucleus acc i = 
          let add pigment gaze = 
	    IntPointMap.add i { pigment; gaze } acc
	  in
	     
	  function | '.'
                   | ' ' -> acc

	           | 'a' -> add Gray Up
                   | 'b' -> add Gray RightUp
                   | 'c' -> add Gray RightDown
                   | 'd' -> add Gray Down
                   | 'e' -> add Gray LeftDown
                   | 'f' -> add Gray LeftUp

		   | 'A' -> add Blue Up
                   | 'B' -> add Blue RightUp
                   | 'C' -> add Blue RightDown
                   | 'D' -> add Blue Down
                   | 'E' -> add Blue LeftDown
                   | 'F' -> add Blue LeftUp
                          
                   |  _  -> raise (Inlegal_case "invalid symbol")

        let load path =
          let root = (module LevelsSourceTree : TREE.ROOT.T) in
          let module Src = 
	    (val (root |> Root.get path.branch
                       |> Branch.get path.branchlet
                       |> Branchlet.get path.leaf) : TREE.LEAF.T) in

          let empty = IntPointMap.empty
          and flora = Lazy.force Src.flora
          and index = 
	    function | Some i -> i
                     | None   ->
                        raise (Inlegal_case "invalid_source") in

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

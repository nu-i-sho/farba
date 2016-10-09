open Data.Shared
open Data.Tissue
open Shared.Fail
open Utils
open LEVEL
   
type flora = cytoplasm IntPointMap.t
type fauna = nucleus IntPointMap.t
            
module type LEVEL  = SOURCE.T
  with type flora := flora
   and type fauna := fauna
         
type t = level_path * (module LEVEL)

let active (_, (module Lvl : LEVEL)) = Lvl.active
let height (_, (module Lvl : LEVEL)) = Lvl.height
let width  (_, (module Lvl : LEVEL)) = Lvl.width
let flora  (_, (module Lvl : LEVEL)) = Lvl.flora
let fauna  (_, (module Lvl : LEVEL)) = Lvl.fauna

let path = fst

module MakeLoader (Tree : SOURCE_TREE.ROOT.T) = struct

  module TREE      = SOURCE_TREE
  module DotsNode  = Shared.DotsNodeMap
  module Root      = DotsNode.Make (TREE.BRANCH)
  module Branch    = DotsNode.Make (TREE.BRANCHLET)
  module Branchlet = DotsNode.Make (TREE.LEAF)
  module Acc       = IntPointMap

  let load path =

    let load_cytoplasm acc i =
      function | ' ' -> acc
               |  x  -> acc |> Acc.add i (Cytoplasm.of_char x)
    
    and load_nucleus acc i =
      function | '.'
               | ' ' -> acc
               |  x  -> acc |> Acc.add i (Nucleus.of_char x)
    
    and root = (module Tree : TREE.ROOT.T) in
    let module Source = 
      (val (root |> Root.item path.branch
                 |> Branch.item path.branchlet
                 |> Branchlet.item path.leaf) : TREE.LEAF.T) in
    path, (module
             (struct
                  include Source
                  let fauna =
                    fauna |> Lazy.force
                          |> Matrix.of_string_list
                          |> Matrix.foldi load_nucleus Acc.empty

                  let flora =
                    flora |> Lazy.force
                          |> Matrix.of_string_list
                          |> Matrix.foldi load_cytoplasm Acc.empty
                end) : LEVEL)
  end

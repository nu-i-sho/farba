type t = {  code : Command.t array;
           label : SolutionLabel.t
         }
       
let label o = o.label
let command i o = o.code.(i)
let length o = Array.length o.code
let to_array o = Array.copy o.code
               
let fold f acc o =
  Array.fold_left f acc o.code
             
module Loader = struct
    let load branch =
      lazy ( let channel =
               open_in ( ".farba/solutions/"
                       ^ (DotsOfDice.to_string branch)
                       ^ ".slns"
                       ) in
      
             let read_line _ = input_line channel in
             let solutions = Array.init (6 * 6 * 6) read_line 
             and () = close_in channel in
             solutions
           )
      
    let root = 
      DotsOfDice.all |> List.map load
                     |> Array.of_list

    let load label =
      let open SolutionLabel in
      let open LevelPath in
      
      let index_of = DotsOfDice.index_of in
      let code = (root.(index_of label.level.branch) |> Lazy.force)
                      .(((index_of label.level.branchlet) * 6 * 6)
                        + ((index_of label.level.leaf) * 6)
                        +  (index_of label.id)) in

      let parse i = Command.of_char code.[i] in
      {  code = Array.init (String.length code) parse;
        label;
      }
  end

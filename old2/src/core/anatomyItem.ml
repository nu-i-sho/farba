module In = struct
    include Shared.AnatomyItem
  end

module Out = struct
    type t = | Colony of Shared.ColonyItem.t
             | Tissue of Shared.TissueItem.t
	     | Out

    let of_in = 
      let open Shared.TissueItem in
      function | In.ActiveCell x -> Tissue (Cell x)
               | In.Colony x     -> Colony x
               | In.Tissue x     -> Tissue x
	       | In.Out _        -> Out
  end

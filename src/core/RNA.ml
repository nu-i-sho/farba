type t = {   kind : Gene.OfSpirit.Kind.t;
	   energy : Gene.OfSpirit.Energy.t list
	 }

let empty = {   kind = Gene.OfSpirit.Kind.ImmovableVirus;
	      energy = []
	    }

module Builder = struct
    type d = { acc : t }

    let make kind = 
      { acc = { empty with kind } }

    let with_energy energy { acc } =
      { acc = { acc with energy } }
    
    let result { acc } = acc

  end

let kind_of x = x.kind
let energy_of x = x.energy

let active_breadcrumb_of rna =

  let open Gene.OfSpirit.Energy in
  let value_of breadcrumb = breadcrumb.value in
  let energy = energy_of rna in
  let min = 
    energy |> List.map value_of 
           |> List.fold_left DotsOfDice.min 
                             DotsOfDice.O
  in

  let is_min breadcrumb =
    (value_of breadcrumb) == min
  in

  let breadcrumb = energy |> List.filter is_min in 
  let [o] = breadcrumb in
  o

let step rna = 
  
  let open Gene.OfSpirit.Kind in
  let kind = kind_of rna in
  match kind with
  | ImmovableVirus -> rna
  | ReinjectingVirus mode 
  | MultiplyingVirus mode ->
     let open Gene.OfSpirit.Energy in
     let breadcrumb = active_breadcrumb_of rna in
     let update_index_of x =
       { x with index = x.index
		      + (match mode with
			 | RunMode.Run 
			 | RunMode.Call   -> +1
			 | RunMode.Return -> -1
			)
       }
     in

     let rec update = 
       function | h :: t when (h.value == breadcrumb.value)
		         -> (update_index_of h) :: t
                | h :: t -> h :: update t
		| []     -> []
     in

     let updated_energy = update (energy_of rna) in
     let _ = Builder.result 
	       (Builder.with_energy updated_energy 
				    (Builder.make kind))
     in
     let _ = kind |> Builder.make
                  |> Builder.with_energy updated_energy
                  |> Builder.result in 
     rna

type t = { cytoplasm : Pigment.t;
             nucleus : Nucleus.t
	 }

let is_cancer =
  function | { cytoplasm = Pigment.White; _ } -> true
           | { nucleus = n; _ } -> Nucleus.is_cancer n

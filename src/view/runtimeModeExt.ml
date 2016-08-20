type t = Data.RuntimeMode.t

let kind_of =
  let module Mode = Data.RuntimeMode in 
  let module Kind = RuntimeModeKind in
  function | Mode.GoTo _ | Mode.Return  -> Kind.Find
           | Mode.Run    | Mode.RunNext -> Kind.Run

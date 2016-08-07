open Data.WeaverActCounter

module ComparableField = struct 
    type t = Field.t

    let to_int = 
      Field.( function | Turn           -> 0
                       | Move           -> 1
		       | Pass           -> 2
		       | Replicate      -> 3
		       | DummyMove      -> 4
		       | DummyPass      -> 5
		       | DummyReplicate -> 6 )
    let compare x y =
      compare (to_int x) (to_int y)
  end
 
module CMap = Map.Make (ComparableField)
type t = int CMap.t

let zero =
  Field.( 
    CMap.empty |> CMap.add Turn 0 
               |> CMap.add Move 0
	       |> CMap.add Pass 0
	       |> CMap.add Replicate 0
	       |> CMap.add DummyMove 0
	       |> CMap.add DummyPass 0
               |> CMap.add DummyReplicate 0
  )

let increment counter o =  
  o |> CMap.remove counter
    |> CMap.add counter ((CMap.find counter o) + 1)

let rec get counter o = 
  let open Field in 
  let open Summary in
  match counter with  
  | Field x           -> CMap.find x o 
  | Summary Effective -> (get (Field Turn) o)
                       + (get (Field Move) o)
                       + (get (Field Pass) o)
                       + (get (Field Replicate) o)
  | Summary Dummy     -> (get (Field DummyMove) o)
                       + (get (Field DummyPass) o)
                       + (get (Field DummyReplicate) o)
  | Summary All       -> (get (Summary Effective) o)
                       + (get (Summary Dummy) o)

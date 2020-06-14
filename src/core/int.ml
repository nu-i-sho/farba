include Int

let load src =
  let is_digit = function
    | '0' .. '9' -> true
    | _          -> false in
  let rec load next acc =
    match next () with
    | Seq.Nil             -> assert false
    | Seq.Cons (v, next') ->
       if not (is_digit v) then
         (acc |> List.rev
              |> List.to_seq
              |> String.of_seq
              |> int_of_string), next' else
         load next' (v :: acc) in
  match src () with 
  | Seq.Nil              -> assert false
  | Seq.Cons ('-', next) -> load next ['-']
  | Seq.Cons _           -> load src []

let unload o =
  o |> string_of_int
    |> String.to_seq 
      
     
    
  

                      

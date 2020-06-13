type e = (Command.t, Dots.t, Dots.t) Statement.t
type t = e list

let empty = []
       
let load =
  let load_statement next =
    match next () with
    | Seq.Cons ('C', next) ->
       let procedure, next = Dots.load next in
       (Statement.Call procedure), next
    | Seq.Cons ('D', next) ->
       let procedure, next = Dots.load next in
       (Statement.Declare procedure), next
    | Seq.Cons ('P', next) ->
       ( match next () with
         | Seq.Cons ('T', next) ->
            ( match next () with
              | Seq.Cons ('L', next) -> 
                 Statement.Perform (Command.Turn Hand.Left), next
              | Seq.Cons ('R', next) ->
                 Statement.Perform (Command.Turn Hand.Right), next
              | Seq.Cons _ | Seq.Nil ->
                 assert false
            )
         | Seq.Cons ('M', next) ->
            ( match next () with
              | Seq.Cons ('B', next) ->
                 Statement.Perform (Command.Move Nature.Body), next
              | Seq.Cons ('M', next) ->
                 Statement.Perform (Command.Move Nature.Mind), next
              | Seq.Cons _ | Seq.Nil ->
                 assert false
            )
         | Seq.Cons ('R', next) ->
            ( match next () with
              | Seq.Cons ('D', next) ->
                 Statement.Perform (Command.Replicate Gene.Dominant), next
              | Seq.Cons ('R', next) ->
                 Statement.Perform (Command.Replicate Gene.Recessive), next
              | Seq.Cons _ | Seq.Nil ->
                 assert false
            )
         | Seq.Cons _ | Seq.Nil ->
            assert false
       )
    | Seq.Cons _ | Seq.Nil ->
       assert false in
  
  let rec load acc next =
    match next () with
    | Seq.Cons ('.', next) -> (List.rev acc), next
    | Seq.Cons _           ->
       let statement, next = load_statement next in  
       load (statement :: acc) next
    | Seq.Nil -> assert false in
  load []

let rec unload = function
  | h :: t -> 
     ( match h with
       | Statement.Perform command   ->
          ( match command with 
            | Command.Turn Hand.Left           -> "PTL"
            | Command.Turn Hand.Right          -> "PTR"
            | Command.Move Nature.Body         -> "PMB"
            | Command.Move Nature.Mind         -> "PMM"
            | Command.Replicate Gene.Dominant  -> "PRD"
            | Command.Replicate Gene.Recessive -> "PRR"
          ) |> String.to_seq
       | Statement.Call procedure    ->
          Seq.append (Seq.return 'C') (Dots.unload procedure)
       | Statement.Declare procedure ->
          Seq.append (Seq.return 'D') (Dots.unload procedure)
     ) |> Seq.append (unload t)
  | []     ->
     Seq.return '.'

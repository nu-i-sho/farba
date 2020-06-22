module Element = struct
  type t = (Command.t, Dots.t, Dots.t) Statement.t

  let load src =
    match src () with
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
       assert false 

  let unload = function
    | Statement.Call procedure    ->
       Seq.append (Seq.return 'C') (Dots.unload procedure)
    | Statement.Declare procedure ->
       Seq.append (Seq.return 'D') (Dots.unload procedure)
    | Statement.Perform command   ->
       ( match command with 
         | Command.Turn Hand.Left           -> "PTL"
         | Command.Turn Hand.Right          -> "PTR"
         | Command.Move Nature.Body         -> "PMB"
         | Command.Move Nature.Mind         -> "PMM"
         | Command.Replicate Gene.Dominant  -> "PRD"
         | Command.Replicate Gene.Recessive -> "PRR"
       ) |> String.to_seq    
  end

type t = Element.t list

let empty = []
       
let load =
  let rec load acc next =
    match next () with
    | Seq.Cons ('.', _) -> (List.rev acc), next
    | Seq.Cons _        ->
       let e, next = Element.load next in  
       load (e :: acc) next
    | Seq.Nil -> assert false in
  load []

let rec unload = function
  | h :: t -> Seq.append (Element.unload h) (unload t)
  | []     -> Seq.empty

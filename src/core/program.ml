type t = Processor.t
       
let rec seq_of_input f () = 
  match f () with
  | '\000' -> Seq.Nil
  | x      -> Seq.Cons (x, seq_of_input f)

let seq_to_output f =
  let out f =
    match f () with
    | Seq.Cons (x, f) -> x, f
    | Seq.Nil         -> '\000', f in
  f, out

let load level =
  let tissue, src =
    level |> seq_of_input
          |> Tissue.load in
  let src = Seq.skip '.' src in
  assert (src () =  Seq.Nil);
  Processor.make tissue Source.empty
  
let restore backup =
  let o, src =
    backup |> seq_of_input
           |> Processor.load in
  assert (src () =  Seq.Nil);
  o

let save o =
  o |> Processor.unload
    |> seq_to_output
 
let () =
  let () = Callback.register "load" load in
  let () = Callback.register "restore" restore in
  let () = Callback.register "save" save in
  ()

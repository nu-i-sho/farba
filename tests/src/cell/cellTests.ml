type dummy_color_t = int

module DummyColor = 
  DummyMakeable.Make 
    (struct type t = char end)
    (struct type t = dummy_color_t end)

module Cell = Cell.Make (DummyColor)
module Test = UniO_Test

type state_t = unit

let name = "Cell Tests"
let set_up   () = ()
let tir_down () = ()

let make_expect (source, product) as case  =
  let () = DummyColor.set_make case in
  let name = 
    Printf.sprintf 
      "If source isn't equel to '-' \
      result equel to \
      'Expect (Color.make source)' #%i" 
      source in
  let run () = 
    assert (Cell.make source) = Expect product 
  in
  Test.({ name; run })  
	  
let make_empty = 
  Test.({ name = "If source is equel to '-' "
               + "result equel to 'Empty'";
	  run  = fun () -> 
	    assert (Cell.make '-') = Cell.empty
	})
  
let tests = 
  [ make_empty;
    make_expect (1, 'x');
    make_expect (2, 'y');
    make_expect (3, 'z')
  ]

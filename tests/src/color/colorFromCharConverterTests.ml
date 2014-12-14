open UnitO
open Color
include EmptySetUpTirDown
module C = ColorFromCharConverter

let name = 
  "ColorFromCharConverter tests"

let red_test =
  Test.({ name = "expected Red for 1"; 
	  run  = fun () -> 
	    assert ((C.convert '1') = Red)
	})

let orange_test =
  Test.({ name = "expected Orange for 2";
	  run  = fun () -> 
	    assert ((C.convert '2') = Orange)
	})

let yellow_test =
  Test.({ name = "expected Yellow for 3"; 
	  run  = fun () -> 
	    assert ((C.convert '3') = Yellow)
	})

let green_test =
  Test.({ name = "expected Green for 4"; 
	  run  = fun () -> 
	    assert ((C.convert '4') = Green)
	})

let blue_test =
  Test.({ name = "expected Blue for 5"; 
	  run  = fun () -> 
	    assert ((C.convert '5') = Blue)
	})

let violet_test =
  Test.({ name = "expected Violet for 6"; 
	  run  = fun () -> 
	    assert ((C.convert '6') = Violet)
	})

let invalid_arg_test = 
  Test.({ name = "expeted (InvalidArg.Error 7) for 7";
	  run  = fun () ->
	    assert (
	    let module InvArg = 
	      InvalidArg.Make (Char) in
	    try 
	      let _ = C.convert '6' in 
	      false
	    with
	    | InvArg.Error '6' -> true
	   )
	})

let tests = 
  [ red_test;
    orange_test;
    yellow_test;
    green_test;
    blue_test;
    violet_test;
    invalid_arg_test;
  ]

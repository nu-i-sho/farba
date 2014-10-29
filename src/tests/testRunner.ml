module Make : MAKE_T = functor
  (Output : OBSERVER.T with type message_t = TestMessage.t) -> struct
    open TestMessage

    type message_t = TestMessage.t
    type output_t = Output.t
    type testSet_t = (module TEST_SET.T)
	     
    let run session ~output =
      let rec run' sets output =
	let rec run'' tests output =
	  match tests with
	  | test :: oth_tests -> begin
	      let module Test = (val test : TEST.T) in
	      output |> Output.send { context = Level.Test;
				        event = Event.Started;
					 time = Unix.time ();
					 name = Test.name;
				      message = ""
				    }
	             |> (try let Test.run () in
		           Output.send { context = Level.Test;
				           event = Event.Passed;
					    time = Unix.time ();
					    name = Test.name;
				         message = ""
				       }
		         with Assert_failure (file, line, char) ->
			   Output.send { context = Level.Test;
				           event = Event.Failed;
					    time = Unix.time ();
					    name = Test.name;
				         message = "file: " + file + "; " 
					         + "line: " + line + "; "
					         + "char: " + char + "; "
				       })
		     |> run'' oth_tests 
	  end
	  | [] -> output
	in
	match sets with 
	| set :: oth_sets -> begin
	    let module Set = (val set : TESTS_SET.T) in
	    output |> Output.send { context = Level.Set;
				      event = Event.Started;
				       time = Unix.time ();
				       name = Set.name;
				    message = ""
				  } 
	           |> run'' Set.children
		   |> Output.send { context = Level.Set;
				      event = Event.Finished;
				       time = Unix.time ();
				       name = Set.name;
				    message = ""
				  }
		   |> run' oth_sets
	end
	| [] -> output
      in
      let module Session = (val session : TESTS_SESSION.T)
      output |> Output.send { context = Level.Session;
			        event = Event.Started;
                                 time = Unix.time ();
			         name = Set.name;
			      message = ""
			    }
             |> run' Session.children
	     |> Output.send { context = Level.Session;
			        event = Event.Finished;
                                 time = Unix.time ();
			         name = Set.name;
			      message = ""
			    }
  end

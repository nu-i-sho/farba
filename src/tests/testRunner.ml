module Make : TESTS_RUNNER.MAKE_T = functor
  (Output : OBSERVER.T with type message_t = TestMessage.t) -> struct
    open TestMessage

    type message_t = TestMessage.t
    type output_t = Output.t
    type testSession_t = 
	(module TESTS_SESSION.T with type child_t = 
	    (module TESTS_SET.T with type child_t = 
		(module TEST.T)))

    let out ~context ~event ~name ~message =
      Output.send { context; event; name; message;
		    time = Unix.time ()
		  }

    let run session ~output:o =
      let rec run' sets o =
	let rec run'' tests o =
	  match tests with
	  | test :: oth_tests -> 
	      let module Test = (val test : TEST.T) in
	      let out event message =
		out ~context:Level.Test
		       ~name:Test.name
                    ~message ~event 
	      in 
	      let run''' = 
		try 
		  let Test.run () in
		  out Event.Passed ""
		with Assert_failure (file, line, char) ->
		  out Event.Failed "file: " + file + "; " 
			         + "line: " + line + "; "
				 + "char: " + char + "; "
	      in
	      o |> out Event.Started ""
	        |> run'''
		|> run'' oth_tests
	  | [] -> o
	in
	match sets with 
	| set :: oth_sets ->
	    let module Set = (val set : TESTS_SET.T) in
	    let out event =
	      out ~context:Level.Set
		     ~name:Set.name
		  ~message:"" ~event 
	    in
	    o |> out Event.Started
	      |> run'' Set.children
	      |> out Event.Finished
	      |> run' oth_sets
	| [] -> o
      in
      let module Session = (val session : TESTS_SESSION.T) in
      let out event =
	out ~context:Level.Session
	       ~name:Session.name
	    ~message:"" ~event 
      in 
      o |> out Event.Started  
        |> run' Session.children
	|> out Event.Finished 
  end

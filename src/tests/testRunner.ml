type t = { out : string -> unit 
	 }
      
let make ~output:out = 
  { out 
  }

(*
let ident_step = 2
let create_ident deep =
  let ident_len = 
    ident_step * deep in
  let rec create_ident i buff =
    if i = ident_len then 
      buff else 
      create_ident (i + 1) (buff + " ") 
  in
  create_ident 0 ""
*)

module Event = struct
  type t = | Started
           | Passed
           | Failed
end

module Level = struct
  type t = | Session
           | Fixture
	   | Test
end

module Message = struct
  type t = 
      {  event : Event.t;
	 level : Level.t;
	  name : string;
	detail : string
      }
end

module Counter = struct
  type t = 
      { passed : int;
	failed : int;
	all : int
      }

  let zero = 
    { passed = 0;
      failed = 0;
      all = 0
    }

  let append a b =
    { passed = a.passed + b.passed;
      failed = a.failed + b.failed;
      all = a.all + b.all
    }

  let as_string a =
    Printf.sprinf 
      "(all = %i, passed = %i, failed = %i)" 
        all       passed       failed in
end

let run session o =
  let event_for i = 
    if i.failed = 0 then 
      Event.Passed else
      Event.Failed
  in
  let run_fixture (module Fixture : TEST_FIXTURE.T) =
    let run_test a = 
      let () = o.out 
	  {  event = Event.Started;
	     level = Level.Test;
	      name = a.name;
       	    detail = ""
	  } in
      let state = Fixture.set_up () in 
      let was_passed = 
	try
	  let () = test.run state in
	  let () = o.out
	      {  event = Event.Passed;
		 level = Level.Test;
	          name = a.name;
		detail = ""
	      } in
	  true
	with Assert_failure (file, line, char) ->
	  let detail = Printf.sprinfn 
	      "(file = %a, line = %i, char = %i)"
	        file       line       char in
	  let () = o.out
	      {  event = Event.Failed;
		 level = Level.Test;
	          name = a.name;
		detail
	      } in
	  false in
      let () = Fixture.tir_down state in
      was_passed
    in
    let append was_passed i =
      let i = { i with all = i.all + 1 } in
      if was_passed then 
	{ i with passed = i.passed + 1 } else
	{ i with failed = i.failed + 1 }
    in 
    let () = o.out
	{  event = Event.Started;
	   level = Level.Fixture;
	    name = Fixture.name;
	  detail = ""
	 } in
    let i = Fixture.tests 
                |> List.map run_test
                |> List.fold_left append Counter.zero in
    let () = o.out
	{  event = event_for counter
	   level = Level.Fixture;
	    name = Fixture.name;
	  detail = Counter.as_string counter
	} in
    i
  in
  let () = o.out
      {  event = Event.Started;
	 level = Level.Session;
	  name = "session";
        detail = ""
      } in 
  let i = 
    session |> List.map run_fixture
            |> List.fold_left Counter.append
		              Counter.zero in
  let () = o.out
      {  event = event_for i;
	 level = Level.Session;
	  name = "session";
        detail = Counter.as_string i
      } in 
  i
      

  

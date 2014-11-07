open TestMessage

let msg ~context ~event ~name ~message =
  { context; event; name; message;
    time = Unix.time ()
  }

module MsgSender = struct
  type t = { send : TestMessage.t -> unit 
	   }

  let make observer = 
    { send = observer 
    }

  let send msg o = 
    o.send msg
end

module RunnerForTest = struct

  type t = MsgSender.t
  type source_t = (module TEST.T)
  
  let make = 
    MsgSender.make

  let run test o = 
    let module Test = (val test : TEST.T) in
    let msg event message =
      msg ~context:Level.Test
	  ~name:Test.name
          ~message ~event 
    in 
    let () = o |> MsgSender.send (msg Event.Started "") in
    let finished_msg = try
      let () = Test.run () in
      msg Event.Passed ""
    with Assert_failure (file, line, char) ->
      msg Event.Failed 
	 (Printf.sprintf "file: %s; line: %i; char: %i."
	                  file      line      char) 
      in
    let () = o |> MsgSender.send finished_msg in
    o
end

module ForTestsSet = struct

  type t = MsgSender.t
  type source_t = (module TESTS_SET.T)

  let make = 
    MsgSender.make

  let run tests_set o =
    let module Set = (val tests_set : TESTS_SET.T) in
    let rec run = function
      | test :: oth -> 
	  let () = o |> RunnerForTest.run test 
	             |> ignore in 
	  run oth
      | [] -> ()
    in
    let msg event =
      msg ~context:Level.Set
	     ~name:Set.name
	  ~message:"" ~event
    in
    let () = o |> MsgSender.send (msg Event.Started) in
    let () = run Set.children in
    let () = o |> MsgSender.send (msg Event.Finished) in
    o 
end

module ForTestsSession  = struct

  type t = MsgSender.t
  type source_t = (module TESTS_SESSION.T)

  let make = 
    MsgSender.make

  let run session o =
    let module Session = (val session : TESTS_SESSION.T) in
    let rec run = function
      | set :: oth -> 
	  let () = o |> ForTestsSet.run set
                     |> ignore in run oth
      | [] -> ()
    in
    let msg event =
      msg ~context:Level.Session
	  ~name:Session.name
	  ~message:"" ~event 
    in 
    let () = o |> MsgSender.send (msg Event.Started) in
    let () = run Session.children in
    let () = o |> MsgSender.send (msg Event.Finished) in
    o
end

include RunnerForTest

module ForTestsSet = struct

  type t = MsgSender.t
  type source_t = (module TESTS_SET.T)

  let make = 
    MsgSender.make

  let run tests_set o =
    let module Set = (val tests_set : TESTS_SET.T) in
    let rec run = function
      | test :: oth  
	  let () = o |> RunnerForTest.run test 
	             |> ignore in 
	  run oth
      | [] -> ()
    in
    let msg event =
      msg ~context:Level.Set
	     ~name:Set.name
	  ~message:"" ~event
    in
    let () = o |> MsgSender.send (msg Event.Started) in
    let () = run Set.children in
    let () = o |> MsgSender.send (msg Event.Finished) in
    o 
end

module type T = sig
  type t
end

module type NAMED = sig
  val name : string
end

module type RUNNABLE = sig
  include T
  val run  : t -> unit
end
constraint
module type NODE = sig
  include NAMED
  include RUNNABLE
end

module MAKEABLE = sig
  include T
  type source_t
  val make : source_t -> t
end

module MAKEABLE_NODE = sig
  include NODE
  include MAKEABLE with type t := t
end

module LEAF = 
  MAKEABLE_NODE with type source_t = unit

module type BRANCH = sig
  type child_t
  val children : t -> child_t list
  include MAKEABLE_NODE with type source_t = child_t list 
end

module type MAKE_BRANCH = functor
    (Sub : NODE) -> 
      BRANCH with type child_t = Sub.t 

module type MESSANGER = functor 
    (Message : MESSAGE) = struct
      type message_t
      
    end

module MakeBranch = functor 
  (Sub : NODE) -> struct
    type child_t = Sub.t
    type source_t = clild_t list
    type t = source_t
    
    let make children =
      children

    let children t = 
      t

    let run t =
      t |> List.iter Sub.run
  end

let tests = 
[ { name = "test some text";
    test = fun () ->
      let x = some_func() in
      let y = some_func() in
      
      assert x = y
  };
  { name = "test other"l
    test = fun () ->
      let x = some_func() in
      let y = some_func() in
      
      assert x = y
  }
]

(* -run one test
   -run tets fixture

*)

module Test = struct
  type 'state t = 
      { name : string;
	run  : 'state -> unit
      }
end

module type TEST_FIXTURE = sig
  type state_t 

  val set_up   : unit -> state_t
  val tir_down : state_t -> unit
  val tests    : (state_t Test.t) list
end

module SomeTest : TEST_FIXTURE = struct
  type state_t = unit 

  let name = "some text fixture name" in
  let set_up () = ()
  let tir_down () = ()

  let tests =
    [ { name = "test some text";
	test = fun () ->
	  let x = some_func () in
	  let y = some_func () in
	
	  assert x = y
      };
      { name = "test other";
	test = fun () ->
	  let x = some_func () in
	  let y = some_func () in
	  
	  assert x = y
      }
    ]
end

module type TESTS_RUNNER = sig
  type t
  val make : output:(string -> unit) -> t

  val run_test : type state_t . 
	(module TEST_FIXTURE with type state_t = state_t) ->
	  (state_t -> unit) -> t -> unit

  val run_tests : type state_t . 
	(module TEST_FIXTURE with type state_t = state_t) ->
	  (state_t -> unit) list -> t -> unit

  val run_fixture : (module TEST_FIXTURE) -> t -> unit
  val run_fixtures : (module TEST_FIXTURE) list -> t -> unit
end

module TestsRunner : TESTS_RUNNER = struct
  type t = { out : string -> unit 
	   }

  let make ~output:out = 
    { out 
    }

  let set_up = function
    | Some f -> Some f ()
    | None   -> None

  let run (module Fixture : TEST_FIXTURE) o =
    let test_stated name = 
      Printf.sprinf 
	"\tTest: %a was started" 
	name 
    in
    let test_passed name = 
      Printf.sprinf 
	"\tTest: %a was passed"
	name
    in
    let test_failed name 
	Assert_failure (file, line, char) = 
      Printf.sprinf 
	"\tTest: %a was failed. (file = %a, line = %i, char = %i)"
	name file line char
    in
    let run tests count failed_count = 
      match tests with
      | test :: tests -> 
	  let () = o.out (test_stated test.name) in
	  let state = Fixture.set_up () in 
	  let was_failed = 
	    try
	      let () = test.run state in
	      let () = o.out (test_passed test.name) in
	      false
	    with (Assert_failure _) as detail -> 
	      let () = o.out (test_failed test.name detail) in
	      true
	  in
	  let () = Fixture.tir_down state in
	  let failed_count = 
	    (if was_failed then 1 else 0) + failed_count 
	  in
	  run tests (count + 1) failed_count 
      | [] -> 
	  (count, failed_count)
    in
    let () = o.out 
	(Printf.sprinf 
	   "\tTest fixture: %a was started" 
	   test.name) 
    in
    let run Fixture.tests 0 0 in
	  

     Fixture.tests |> List.iter
end
  

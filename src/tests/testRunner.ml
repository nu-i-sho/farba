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

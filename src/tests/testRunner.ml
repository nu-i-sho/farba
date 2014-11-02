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



module Level = struct
  type t = | Session
           | Set
	   | Test
end

module Event = struct
  type t = | Started
           | Failed
	   | Passed
	   | Finished
end

type t = { context : Level.t;
             event : Event.t;
              time : float;
	      name : string;
	   message : string
	 }

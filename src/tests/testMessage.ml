module rec Level = struct
  type t = | Session
           | Set
	   | Test
end

module Event = struct
  type t = | Started
           | Failed
	   | Passed
	   | FInished
end

type t = { context : Level.t;
             stage : Event.t;
              time : Unix.tm;
	      name : string;
	   message : string
	 }
end

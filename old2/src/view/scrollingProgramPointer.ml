module Slide = struct
    type t = {   size : int;
	       number : int;
                first : int;
                 last : int
	     }
  end

type t = { donor : ProgramPointer.t;
	   count : int;
	   slide : Slide.t;
	   point : Point.t
	 }

let make         ~donor:d
        ~commands_count:cmd_count
     ~scrin_lines_count:ln_count = 
  
  { donor = d;
    count = cmd_count;
    point = (0, 0)
    slide = {   size = ln_count;
	      number = 0;
               first = 0;
                last = ln_count - 1
	    } 
  }

let point_of o = 
  o.point

let get i o = 
  let module Ptr = ProgramPointer in
  let ptr = Ptr.get i o.donor in 
  let x, y = Ptr.point_of ptr in


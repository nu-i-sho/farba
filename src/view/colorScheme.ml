type command_t =
  {     act : char -> Graphics.color;
     finish : char -> Graphics.color;
    declare : char -> Graphics.color;
       call : char -> Graphics.color
  }

type call_stack_point_t =
  {  run : char -> Graphics.color;
    find : char -> Graphics.color
  }

type tissue_t =
  { clot   : Graphics.color;
    virus  : Graphics.color;
    line   : Graphics.color; 
    white  : Graphics.color;
    blue   : Graphics.color;
    gray   : Graphics.color;
  }
  
type t = { call_stack_point : call_stack_point_t;
                    command : command_t;
                     tissue : tissue_t
         }           
  
let default =
  let command_map_for_act =
    function | 'H' -> Color.khaky
             | '~' -> Color.gray
	     | '-' -> Color.white
             | ' ' -> Color.empty
             |  _  -> failwith "unmapped char"
  and command_map_for_finish =
    function | 'H' -> Color.blue
             | '-' -> Color.white
	     | ' ' -> Color.empty
             |  _  -> failwith "unmapped char"
  and command_map_for_declare =
    function | 'H' -> Color.blue
             | '-' -> Color.white
	     | ' ' -> Color.empty
             |  _  -> failwith "unmapped char"
  and command_map_for_call =
    function | 'H' -> Color.gray 
             | '-' -> Color.white
             | ' ' -> Color.empty
             |  _  -> failwith "unmapped char" 
  and call_stack_point_map_for_run =
    function | 'H' -> Color.black
             | '-' -> Color.white
	     | ' ' -> Color.empty
             |  _  -> failwith "unmapped char"
  and call_stack_point_map_for_find =
    function | 'H' -> Color.white
             | '-' -> Color.black
	     | ' ' -> Color.empty
             |  _  -> failwith "unmapped char"
  in

  let color_scheme_for_command =
    {     act = command_map_for_act;
       finish = command_map_for_finish;
      declare = command_map_for_declare;
         call = command_map_for_call
    }
  and color_scheme_for_call_stack_point =
    {  run = call_stack_point_map_for_run;
      find = call_stack_point_map_for_find
    }
  and color_scheme_for_tissue = 
    {  clot = Color.red;
      virus = Color.yellow;
       line = Color.black;  
      white = Color.white;
       blue = Color.blue;
       gray = Color.gray 
    }
  in

  { call_stack_point = color_scheme_for_call_stack_point;
             command = color_scheme_for_command;
              tissue = color_scheme_for_tissue;
  }

module Command = struct
    let act     o = o.command.act
    let finish  o = o.command.finish
    let declare o = o.command.declare
    let call    o = o.command.call
  end

module CallStackPoint = struct
    let run  o = o.call_stack_point.run
    let find o = o.call_stack_point.find
  end

module Tissue = struct
    let clot   o = o.tissue.clot
    let virus  o = o.tissue.virus
    let line   o = o.tissue.line
    let white  o = o.tissue.white
    let blue   o = o.tissue.blue
    let gray   o = o.tissue.gray
  end

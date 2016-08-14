type for_command_t =
  {     map_for_act : char -> Graphics.color;
        map_for_end : char -> Graphics.color;
    map_for_declare : char -> Graphics.color;
       map_for_call : char -> Graphics.color
  }

type for_call_stack_point_t =
  {  map_for_run : char -> Graphics.color;
    map_for_find : char -> Graphics.color
  }

type t = { for_call_stack_point : for_call_stack_point_t;
                    for_command : for_command_t
         }           

module Color = struct

    let blue  = 0x4682B4
    let gray  = 0x808080
    let khaky = 0xF0E68C
    let white = 0xF8F8FF
    let black = 0x000000
    let empty = -1 
  
  end
       
let default =
  let command_map_for_act =
    function | 'H' -> Color.khaky
             | '~' -> Color.gray
	     | '-' -> Color.white
             | ' ' -> Color.empty
             |  _  -> failwith "unmapped char"
  and command_map_for_end =
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

  let color_sheme_for_command =
    {     map_for_act = command_map_for_act;
          map_for_end = command_map_for_end;
      map_for_declare = command_map_for_declare;
         map_for_call = command_map_for_call
    }
  and color_sheme_for_call_stack_point =
    {  map_for_run = call_stack_point_map_for_run;
      map_for_find = call_stack_point_map_for_find
    }
  in

  { for_call_stack_point = color_sheme_for_call_stack_point;
             for_command = color_sheme_for_command
  }

module ForCommand = struct
    let map_for_act     o = o.for_command.map_for_act
    let map_for_end     o = o.for_command.map_for_end
    let map_for_declare o = o.for_command.map_for_declare
    let map_for_call    o = o.for_command.map_for_call
  end

module ForCallStackPoint = struct
    let map_for_run  o = o.for_call_stack_point.map_for_run
    let map_for_find o = o.for_call_stack_point.map_for_find
  end

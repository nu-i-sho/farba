open Data

type focus_line_t = ProgramLine.t
type active_focus_line_t = (int * ProgramActiveLine.t) option
                         
type t = { focus_height : int;
             first_line : int FocusTriger.t;
                 center : int;
                   base : SnakeProgram.t
         }

module Program = SnakedProgram
module Trigger = FocusTrigger

let active_line_index base =
    ProgramActiveLine.(
      (Program.active_line base).index
    )
               
let extend program height =
  let center = CenterCalculator.calulate_for height
  and i = active_line_index program in
  { focus_height = height;
      first_line = Trigger.make (up_limited (i - center));
            base = program;
          center;          
  }

let length       o = o.base |> Program.length
let height       o = o.base |> Program.height
let width        o = o.base |> Program.width
let active_item  o = o.base |> Program.active_item
let maybe_item i o = o.base |> Program.maybe_item i
let item       i o = o.base |> Program.item i
let active_line  o = o.base |> Program.active_line
let maybe_line i o = o.base |> Program.maybe_line i
let line       i o = o.base |> Program.line i

let focus_height o = o.focus_height

let up_limited =
  max 0
  
let down_limited o =
  min ((height o) - 1)
                   
let set_focus_center i o =
  let first =
    (((o.first_line |> Trigger.value) - i + o.center)
                    |> up_limited
                    |> down_limited o
                    |> Trigger.with_value) o.first_line in
  
  { o with first_line = first;
               center = i;
  }
  
let scroll_up i o =
  let first =
    (((o.first_line |> Trigger.swap_to_scroll
                    |> Trigger.value) - i)
                    |> up_limited
                    |> Trigger.with_value) o.first_line in

  { o with firs_linet = first }
  
let increase i o first_line =
  (((first_line |> Trigger.value) + i)
                |> down_limited o
                |> Trigger.with_value) first_line

let scroll_down i o =
  let first =
    o.first_line |> Trigger.swap_to_scroll 
                 |> increase i o in
  
  { o with first_line = first }

let focus_line i o =
  line ((Trigger.value o.first_line) + i) o

let maybe_focus_line i o =
  if i >= 0 && i < o.focus_height then
    maybe_line i o else
    None

let active_focus_line o =
  let center_line = focus_line o.center in 
  if ProgramLine.(center_line.is_active) then
    Some (o.center, center_line) else
    let find i =
      ProgramLine.(
        match maybe_focus_line i o with
        | Some (({ is_active = true; _ }) as line) 
                 -> Some (i, line)
        | Some _ -> find (succ i)
        | None   -> None
      ) in
    find 0
  
let succ o =
  let prev = active_line_index o.base
  and base = Program.succ o.base in
  let curr = active_line_index base
           
  and first = Trigger.swap_to_run o.first_line in 
  let first_value = Trigger.value first_line in 
  let first = if (prev <> curr) && (first_value > o.center) then
                first |> increase 1 o else
                first in

  { o with first_line = first;
           base
  }

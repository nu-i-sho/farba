open Data
open Tools

type line_t = StackableProgramLine.t
            
type t =  {     top : (int * ProgramLine.t) IntMap.t;
            program : ScrollableProgram.t;            
             bottom : (int * ProgramLine.t) IntMap.t
          }

module Program = ScrollableProgram
        
let make width lines_count code crumbs =
  {     top = IntMap.empty;
    program = Program.make width lines_count code crumbs;
     bottom = IntMap.empty
  }

let width  o = Program.width  o.program
let crumbs o = Program.crumbs o.program
             
let lines_count o = IntMap.cardinal o.top
                  + Program.lines_count o.program
                  + IntMap.cardinal o.bottom

let line i o =
  StackableProgramLine.(
    
    if IntMap.mem i o.top then
      let x, line = IntMap.find i o.top in
      x, (Some (Stack line))
    else

    if IntMap.mem i o.bottom then
      let x, line = IntMap.find i o.bottom in
      x, (Some (Stack line))
    else

    match Program.line i o.program with
    | x, (Some line) -> x, (Some (Main line))
    | x,  None       -> x,  None
  )

let program_line i program =
  match Program.line i program with
  | _, None      -> failwith Fail.impossible_case
  | x, Some line -> x, line

let has_crumbs line program =
  ProgramLine.( ProgramPoint.(
    match line with
    | x, (FromLeftToRight _)
    | x, (FromRightToLeft _)
      -> Breadcrumbs.exists_in_range
           x (program |> Program.width)
             (program |> Program.crumbs)
    | _, (LeftPoint  { crumb = None; _ })
    | _, (RightPoint { crumb = None; _ })
      -> false
    | _, (LeftPoint  _)
    | _, (RightPoint _)
      -> true
  ))

let pop next extremum o =  
  let rec pop previous_line count stack =
    let i, ((x, _) as stack_line) = extremum stack in
    let y, program_line =
      match previous_line with
      | None   -> program_line (next i) o.program
      | Some x -> x in
    
  if (next x) = y then   
    pop (Some stack_line) (count + 1)
        (IntMap.remove i stack) else
    count, stack in
  pop None 0
  
let push next extremum o =
  let rec push i stack =
    let line = program_line i o.program in
    if has_crumbs line o.program then
      let j, _  = extremum stack in
      let stack = IntMap.add j line stack in
      push (next i) stack else
      i, stack in
  push

let inc x = x + 1
let dec x = x - 1
  
let pop_top     o = pop  inc IntMap.max_binding o o.top
let pop_bottom  o = pop  dec IntMap.min_binding o o.bottom
let push_top    o = push inc IntMap.max_binding o 0 o.top
let push_bottom o =
  push dec IntMap.min_binding o
       ((Program.lines_count o.program) - 1)
       o.bottom

let move (pushed, push_stack)
         (popped, pop_stack)
          push_resize
          pop_resize
          move
          o =
  
  let program =
    if pushed = 0 then o.program else
      push_resize ((Program.lines_count o.program) - pushed)
                    o.program in
  
  let program = move program in
  let program =
    if popped = 0 then program else
      pop_resize ((Program.lines_count program) + popped)
                   program in
  push_stack,
  pop_stack,
  program

let move_up o =
  let top, bottom, program =
    move (push_top o) (pop_bottom o)
         Program.resize_up
         Program.resize_down
         Program.move_up
         o in
  { top;
    program;
    bottom
  }

let move_down o =
  let bottom, top, program =
    move (push_bottom o) (pop_top o)
         Program.resize_down
         Program.resize_up
         Program.move_down
         o in
  { top;
    program;
    bottom
  }

let focus o = 
  let rec focus top program =
    let x, _ = Program.line 0 program
    and last = (IntMap.cardinal top) - 1 in
    let y, _ = IntMap.find last top in
    let diff = y - x in
    let size = (Program.lines_count program) + 1 in 
      
    if diff = -1 then
      focus (IntMap.remove last top)
            (Program.resize_up size program) else

    if diff <= 1 then
      focus (IntMap.remove last top)
            (program |> Program.resize_up size
                     |> Program.focus) else
    {     top;
      program;
       bottom = IntMap.empty
    } in
  
  let size = Program.lines_count o.program
           + IntMap.cardinal o.bottom in
  
  o.program |> Program.resize_down size
            |> focus o.top
      
let with_crumbs x o =
  let program = Program.with_crumbs x o.program in
  focus { o with program }

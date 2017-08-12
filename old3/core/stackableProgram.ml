open Data

type stack_t = {    top : ProgramLine.t list;
                 bottom : ProgramLine.t list
               }

type focus_line_t = StackableProgramLine.t
type focus_active_line_t = StackableProgramActiveLine.t
                  
type t = { program : ScrollableProgram.t;
             stack : stack_t FocusTrigger.t;
            center : int
         }

module Program = ScrollableProgram
module Trigger = FocusTrigger

let adapt program =
  
            
let make width focus_height code =
  { program = Program.make width focus_height code;
      stack = Focus.make { top = []; bottom = [] };
     center = CenterCalculator.calulate_for focus_height
  }

let length       o = o.program |> Program.length
let height       o = o.program |> Program.height
let width        o = o.program |> Program.width
let focus_height o = o.program |> Program.focus_height
let maybe_item i o = o.program |> Program.maybe_item i
let item       i o = o.program |> Program.item i
let active_item  o = o.program |> Program.active_item
let maybe_line i o = o.program |> Program.maybe_line i
let line       i o = o.program |> Program.line i
let active_line  o = o.program |> Program.active_line

let focus_line i o =
  let line is_stack base_line =
    StackableProgramLine.(
      {   is_stack;
         is_active = ProgramLine.(base_line.is_active);
        has_crumbs = ProgramLine.(base_line.has_crumbs);
             index = ProgramLine.(base_line.index);
             value = ProgramLine.(base_line.value)
      }
    ) in
  
  let stack = Focus.value o.stack in
  if i < List.length stack.top then
    line true (List.nth i stack.top) else

    let diff = (focus_height o) - (List.length stack.bottom) in
    if i >= diff then
      line true  (List.nth (i - diff) stack.bottom) else
      line false (Program.focus_line o.program)
    
type sroll_utility_t =
  {   scroll : int -> Program.t -> Program.t;
     storage : stack_t -> ProgramLine.t list;
    extremum : t -> ProgramLine.t list -> int;
        move : int -> int -> int;
     is_over : int -> int -> bool;
        save : ProgramLine.t list -> stack_t -> stack_t 
  }

let top_sroll_utility =
  let save top stack = { stack with top } in
  {   scroll = Program.sroll_up;
     starage = (function | { top = x; _ } -> x);
    extremum = (function | _ -> List.length);
        move = (-);
     is_over = (<);
        save
  }

let bottom_scroll_utility =
  let extremum o bottom =
    (focus_height o) - (List.length bottom) - 1
  and save bottom stack = { stack with bottom } in
  {   scroll = Program.scroll_down;
     starage = (function | { bottom = x; _ } -> x);
    extremum;
        move = (+);
     is_over = (>);
        save
  }

let scroll popping pushing scroll_base i o =
  ProgramLine.(
    let program = popping.scroll i o.program
    and stack_trigger = Trgger.swap_to_scroll o.stack in
    let stack = Trgger.value stack_trigger in
    
    let popping_storage =
      let rec update i =
        let { index = j; _ } = Program.focus_line i program in
        function | { index = l; _ } :: tl when (l + 1) >= j
                      -> update (popping.move i 1) tl
                 | tl -> tl in
      
      let storage = popping.starage stack in
      update (popping.extremum o storage) storage

    and pushing_storage =
      let rec update j l ((k, storage) as acc) =
        if pushing.is_over j l then update' acc else
          ( match Program.line j o.program with
            | { has_crumbs = false; _ }         -> acc
            | { has_crumbs = true; _  } as line ->
               (k + 1), (line :: storage)
          ) |> update (pushing.move j 1) l
        
      and update' (k, storage) =
        if k = 0 then storage else
          let { index = j; _ } =
            Program.focus_line (pushing.extremum storage) program in
          update j (pushing.move j k) (0, storage)
      in

      let storage = pushing.storage stack in
      let extremum = pushing.extremum storage in
      let { index = j; _ } = Program.focus_line extremum o.program
      and { index = l; _ } = Program.focus_line extremum program in
      update j l (0, storage)
    in

    let stack_trigger =
      Trigger.with_value
        (stack |> pushing.save pushing_storage
               |> popping.save popping_storage)
         stack_trigger in
    
    { o with stack = stack_trigger;
           program
    }
  )

let scroll_up   = scroll top_sroll_utility bottom_sroll_utility
let scroll_down = scroll bottom_sroll_utility top_sroll_utility

(*

let scroll_to j o =
  StackableProgramLine.(
    let { index = l; _ } = focus_line o.center o.program in
    match l - j with
    | 0                  -> o
    | i    when i > 0    -> scroll_down i o
    | i (* when i < 0 *) -> scroll_up (abs i) o in
  )                   

 *)

let tick o =
  
  ()

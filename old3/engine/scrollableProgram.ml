type line_t = Program.line_t
type t = { lines_count : int;
            first_line : int;
                  base : Program.t;
         }

let make width lines_count code crumbs =
  { lines_count;
     first_line = 0;
           base = Program.make width code crumbs
  }

let width  o = o.base |> Program.width
let crumbs o = o.base |> Program.crumbs
let line i o = o.base |> Program.line i

let lines_count o = o.lines_count
                    
let move_up o =
  { o with first_line = max (o.first_line - 1) 0 }

let move_down o =
  { o with first_line = min (o.first_line + 1)
                           ((Program.lines_count o.base) - 1)
  } 

let line i o =
  let j = o.first_line + i in
  if i < o.lines_count && i >= 0 then
    Program.line j o.base else
    (j, None)

let period o = (width o) + 1
let line_of command o = (command / (period o) * 2)
                      + (command mod (period o))

let focus o =
  let top_crumb = Breadcrumbs.top_index (crumbs o) in
  let top_crumb_line = (top_crumb / (period o) * 2)
                     + (top_crumb mod (period o))
  and center_line    = (o.lines_count / 2)
                     + (o.lines_count mod 2) in
  let first_line = min (max 0 (top_crumb_line - center_line))
                       ((Program.lines_count o.base) - 1) in
  { o with first_line }
                      
let with_crumbs x o =
  focus { o with base = Program.with_crumbs x o.base }

let rec resize_up only lines_count o =
  let diff = o.lines_count - lines_count in
  let i = o.first_line + diff in
  let o = { o with lines_count = o.lines_count - diff + (min i 0);
                    first_line = max i 0
          } in

  if not only && i < 0 then
    o |> resize_down true lines_count else
    o

and resize_down only lines_count o =
  let max_lines_count =
    (Program.lines_count o.base) - o.first_line in
  let o = { o with lines_count = min max_lines_count lines_count
          } in
  
  if not only && max_lines_count < lines_count then
    o |> resize_up true lines_count else
    o

let resize_up   = resize_up false
let resize_down = resize_down false

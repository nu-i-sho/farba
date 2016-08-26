type t = { view_height : int;
            first_line : int;
                  base : Program.t;
         }

let make width view_height code crumbs =
  { view_height;
     first_line = 0;
           base = Program.make width code crumbs
  }

let width         o = o.base |> Program.width
let lines_count   o = o.base |> Program.lines_count
let crumbs        o = o.base |> Program.crumbs
let line        i o = o.base |> Program.line i

let view_lines_count o = o.view_height
                    
let up o =
  { o with first_line = max (o.first_line - 1) 0 }

let down o =
  { o with first_line = min (o.first_line + 1)
                           ((lines_count o) - 1)
  } 
  
let view_line i o =
  if i >= o.view_height then
    ProgramLine.Empty else
    Program.line (o.first_line + i) o.base

let line_of command o = (command / ((width o) + 1) * 2)
                        + (command mod ((width o) + 1))

let to_center o =
  let top_crumb = Breadcrumbs.top_index (crumbs o) in
  let top_crumb_line = (top_crumb / ((width o) + 1) * 2)
                     + (top_crumb mod ((width o) + 1)) in
  let center_line    = (o.view_height / 2)
                     + (o.view_height mod 2) in
  let first_line = min (top_crumb_line + center_line)
                       ((lines_count o) - 1) in
  { o with first_line }
  
let with_crumbs x o =
  to_center { o with base = Program.with_crumbs x o.base }

let resize view_height o =
  to_center { o with view_height }

open Data
open Tools

type t = { lines_count : int;
            first_line : int;
                 width : int;
                  code : Command.t array;
                crumbs : Breadcrumbs.t;
         }

let make width code crumbs =
  let code_length = Array.length code in
  let lines_count = (code_length / (width + 1) * 2)
                  + (code_length mod (width + 1)) in
  { lines_count;
     first_line = 0;
          width;
           code;
         crumbs
  }

let lines_count o = o.lines_count
let width o = o.width
let crumbs o = o.crumbs
let with_crumbs x o = { o with crumbs = x }

let get i o =
  ProgramPoint.(
    {   crumb = Breadcrumbs.point i o.crumbs;
      command = Array.get o.code i
    }
  )
  
let line_vector first_command o =
  let length = min ((Array.length o.code) - first_command) o.width
  and get i = get (i + first_command) o in
  Vector.make get length
  
let line i o =
  ProgramLine.(
    let i = o.first_line + i in
    if i < 0 || i > o.lines_count then Empty else 
      let j = (i / 2) * (o.width + 1)
            + ( match i mod 2 with
                | 1 -> o.width
                | 0 -> 0
                | _ -> failwith Fail.impossible_case
              ) in
      
      match i mod 4 with
      | 0 -> FromLeftToRight (line_vector j o) 
      | 1 -> Right (get j o)
      | 2 -> FromRightToLeft (line_vector j o)
      | 3 -> Left  (get j o)
      | _ -> failwith Fail.impossible_case
  )

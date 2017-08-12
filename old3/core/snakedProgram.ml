open Data
open Tools

type t = { height : int;
            width : int;
             base : Program.t
         }

let extend program width =
  let length = Program.length program in
  let height = (length / (width + 1) * 2)
             + (length mod (width + 1)) in
  { height;
    width;
    base
  }

let length      o = o.base |> Program.length
let output      o = o.base |> Program.output
let active_item o = o.base |> Program.active_item
let maybe_item  o = o.base |> Program.maybe_item
let item      i o = o.base |> Program.item i
let succ        o = o.base |> Program.succ

let height o = o.height
let width  o = o.width
                   
let line i o =
  
  let j = (i / 2) * (o.width + 1)
        + (if i mod 2 = 1 then o.width else 0) in
  
  ProgramLine.(
    let line_kind = i mod 4 in
    match line_kind with
    | 0 | 2 -> let length = min ((length o) - j) o.width
               and item l = item (l + j) o in
               let vector = Vector.make item length
               and crumbs = Program.crumbs o.base in
               
               let top_crumb, _ = Crumbs.top crumbs in
               let is_active  = (top_crumb >= j)
                             && (top_crumb < length) in
               
               {  is_active;
                 has_crumbs = is_active ||
                                (Crumbs.exists j length crumbs);
                      index = i;
                      value = if line_kind = 0 then
                                Value.FromLeftToRight vector else 
                                Value.FromRightToLeft vector
               }
             
    | 1 | 3 -> let item = item j o in
               let has_crumbs, is_active =
                 ProgramItem.( ProgramCrumb.( CrumbStage.(
                   match item.crumb with
                   | None                         -> false, false
                   | Some { stage = Wait; _ }     -> true,  false
                   | Some { stage = Active _; _ } -> true,  true
                 ))) in
               
               {  is_active;
                 has_crumbs;
                      index = i;
                      value = if line_kind = 1 then
                                Value.Right item else
                                Value.Left  item
               }
                         
    | _     -> failwith Fail.impossible_case
  )

let maybe_line i o =
  if i >= 0 && i < o.height then
    Some (line i o) else
    None
  
let active_line o =
  let period = (width o) + 1
  and j = ProgramActiveItem.( ProgramCrumb.(
            fst (active_item o).crumb.value
          )) in
  let i = (j / period * 2)
        + (j mod period) in

  let line = line i o in
  ProgramActiveLine.(
      { index = ProgramLine.(line.index);
        value = ProgramLine.(line.value)
      })

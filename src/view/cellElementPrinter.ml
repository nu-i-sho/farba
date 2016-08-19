type t = { canvas : Canvas.t;
            scale : Scale.t;
           colors : TissueColorScheme.t;
           coords : float * float
         }
       
let make canvas scale colors =
  { canvas; scale; colors; coords = 0.0, 0.0 }
  

let set_index (x, y) o =
  let y  = y * 2 + (compare 1 (x mod 2))
  and r1 = Scale.Hexagon.external_radius o.scale
  and r2 = Scale.Hexagon.internal_radius o.scale in
  { o with coords = (r1 +. (float x) *. r1 *. 1.5),
                    (((float y) +. 1.0) *. r2)
  }

let set_color c o =
  { o with canvas = Canvas.set_color c o.canvas }

open TissueColorScheme

let set_color_for_cancer o = o |> set_color o.colors.white
let set_color_for_clot   o = o |> set_color o.colors.clot
let set_color_for_virus  o = o |> set_color o.colors.virus
let set_color_for_line   o = o |> set_color o.colors.line     

let set_color_for_pigment p o =
  o |> set_color Data.Pigment.(
                   match p with
                   | White -> o.colors.white
                   | Blue  -> o.colors.blue
                   | Gray  -> o.colors.gray
                 )
let round num =
  let fractional, integral = modf num in
  (int_of_float integral) 
  + (if fractional > 0.5 then 
       1 else 
       0)
  
let apply_hexagon f o =
  let angles = o.scale |> Scale.Hexagon.angles 
                       |> Array.map (Pair.sum (+.) o.coords)
                       |> Array.map (Pair.map round) in
  { o with canvas = f angles o.canvas }
  
let draw_hexagon =
  apply_hexagon Canvas.draw_poly
  
let fill_hexagon =
  apply_hexagon Canvas.fill_poly

let coords o =
  Pair.map round o.coords

let apply_circle f r o =
  { o with canvas = f (coords o) (round r) o.canvas }
  
let nucleus_r o =
  Scale.Nucleus.radius o.scale
  
let draw_nucleus o =
  apply_circle Canvas.draw_circle (nucleus_r o) o

let fill_nucleus o =
  apply_circle Canvas.fill_circle (nucleus_r o) o

let apply_open_eyes f gaze o =
  let eyes_radius = o.scale |> Scale.Nucleus.eyes_radius
                            |> round in
  let f canvas eye = f eye eyes_radius canvas in
  { o with canvas = o.scale |> Scale.Nucleus.eyes_coords gaze 
                            |> Pair.map (Pair.sum (+.) o.coords)
                            |> Pair.map (Pair.map round)
                            |> Pair.fold f o.canvas
  }
  
let draw_open_eyes =
  apply_open_eyes Canvas.draw_circle

let fill_open_eyes =
  apply_open_eyes Canvas.fill_circle

let draw_lined_eyes lines o =
  let draw_line o (p1, p2) =
    { o with canvas = o.canvas |> Canvas.lineto p1
                               |> Canvas.moveto p2
    } in
  lines |> List.map (Pair.map (Pair.sum (+.) o.coords))
        |> List.map (Pair.map (Pair.map round))
        |> List.fold_left draw_line o

let draw_engry_eyes gaze o =
  draw_lined_eyes (Scale.Cancer.eyes_coords gaze o.scale) o

let draw_clotted_eyes gaze o =
  draw_lined_eyes (Scale.Clot.eyes_coords gaze o.scale) o

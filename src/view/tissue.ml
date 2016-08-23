type t = | Maked of TissueFrame.t
         | Inited of CellElementPrinter.t

open Data
open Nucleus
open Cell
   
module P = CellElementPrinter
         
let make frame =
  Maked frame

let init height width o =
  match o with
  | Inited _
    -> failwith Fail.cannot_reinit_state
  | Maked frame
    -> TissueFrame.(
         let scale =
           Scale.make frame.height frame.width height width in
         let printer = P.make frame.canvas scale frame.colors in 
         Inited printer
       )
     
let nope printer = printer
let print_cytoplasm pigment printer =
  printer |> P.set_pigment_color pigment
          |> P.fill_hexagon
          |> P.set_line_color
          |> P.draw_hexagon
  
let fill_nucleus pigment printer =
  printer |> P.set_pigment_color pigment
          |> P.fill_nucleus

let fill_nucleus_eyes pigment gaze printer =
  printer |> P.set_pigment_color pigment
          |> P.fill_open_eyes gaze

let print_nucleus is_active is_cancer x printer =
  printer |> fill_nucleus x.pigment
          |> ( match is_cancer with
               | true  -> nope
               | false -> let p = Pigment.opposite x.pigment in
                          fill_nucleus_eyes p x.gaze )
          |> ( match is_active with
               | true  -> P.set_virus_color
               | false -> P.set_line_color )
          |> P.draw_nucleus
          |> ( match is_cancer with
               | true  -> P.draw_engry_eyes x.gaze
               | false -> P.draw_open_eyes  x.gaze )
       
let print_cell is_active x printer =
  printer |> print_cytoplasm x.cytoplasm
          |> print_nucleus is_active (Cell.is_cancer x) x.nucleus
          
let init_item i init o =
  match o with
  | Maked _
    -> failwith Fail.state_is_not_inited
  | Inited printer
    -> let open TissueItemInit in
       Inited (printer |> P.set_index i
                       |> ( match init with
                            | Out         -> nope
                            | Cytoplasm x -> print_cytoplasm x
                            | Static cell -> print_cell false cell
                            | Active cell -> print_cell true  cell
                          ))

let draw_nucleus_fully cell printer =
  printer |> P.draw_nucleus
          |> ( if Cell.is_cancer cell then
                 P.draw_engry_eyes else
                 P.draw_open_eyes) cell.nucleus.gaze
         
let update_item i update o =
  match o with
  | Maked _
    -> failwith Fail.state_is_not_inited
  | Inited printer
    -> Inited
         ( let open TissueItemUpdate in
           match update with
           | Inject (_, current)
             -> printer |> P.set_index i
                        |> print_nucleus (Cell.is_cancer current)
                                          true current.nucleus 
           | Extract (_, current)
             -> printer |> P.set_index i
                        |> fill_nucleus current
           
           | Turn (previous, current)
             -> let prev, curr = previous.nucleus,
                                 current.nucleus in
                if Cell.is_cancer current then
                  printer |> P.set_index i
                          |> P.set_pigment_color curr.pigment
                          |> P.draw_engry_eyes prev.gaze
                          |> P.set_virus_color
                          |> P.draw_engry_eyes curr.gaze else
                  printer |> P.set_index i
                          |> fill_nucleus_eyes curr.pigment
                                               prev.gaze
                          |> fill_nucleus_eyes
                               (Pigment.opposite curr.pigment)
                                curr.gaze
                          |> P.set_virus_color
                          |> P.draw_open_eyes curr.gaze

           | VirusOut (_, current)
             -> printer |> P.set_index i
                        |> P.set_line_color
                        |> draw_nucleus_fully current
           
           | Infect (_, current)
             -> printer |> P.set_index i
                        |> P.set_virus_color
                        |> draw_nucleus_fully current
           
           | DoClot (_, current)
             -> printer |> P.set_index i
                        |> P.set_clot_color
                        |> P.fill_hexagon
                        |> P.set_line_color
                        |> P.draw_hexagon
                        |> P.draw_clotted_eyes current
           
           | MoveOut current
             -> let is_cancer = Nucleus.is_cancer current in
                printer |> P.set_index i
                        |> print_nucleus true is_cancer current
         )

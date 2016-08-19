type t = Graphics.image

open CONTRACTS

let of_prototype color_of_char (module Prototype : PROTOIMAGE.T) =
  
  let lines  = Lazy.force Prototype.matrix in
  let width  = Array.length lines
  and height = String.length lines.(0) in  
             
  let parse y x   = color_of_char lines.(y).[x] in
  let parse_row y = Array.init height (parse y) in
  let matrix      = Array.init width  parse_row in

  Canvas.Image.make matrix

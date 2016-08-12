type t = { shift : (int * int) -> (int * int); 
              dx : int;
              dy : int
         }

let open_window height width =
  Graphics.open_graph ( " "
                      ^ (string_of_int height)
                      ^ "x"
                      ^ (string_of_int width)
                      )  
let inv y =
  (Graphics.size_y ()) - y

let root =
  let inv_y (x, y) = x, inv y in
  { shift = inv_y;
       dx = 0;
       dy = 0
  }

let sub dx dy parent =
  let dx = dx + parent.dx
  and dy = dy + parent.dy
  and shift (x, y) = (x + dx), (inv (y + dy)) in
  { shift; dx; dy }

let set_color x o =
  let () = Graphics.set_color x in
  o
  
let set_line_width x o =
  let () = Graphics.set_line_width x in
  o

let draw_poly ps o =
  let () = Graphics.draw_poly (Array.map o.shift ps) in
  o

let draw_ellipse point rx ry o =
  let x, y = o.shift point in
  let () = Graphics.draw_ellipse x y rx ry in
  o

let draw_circle point r o =
  let x, y = o.shift point in
  let () = Graphics.draw_circle x y r in
  o

let draw_arc ((x, y) as point) rx ry a1 a2 o =
  let x, y = o.shift point in
  let () = Graphics.draw_arc x y rx ry a1 a2 in
  o
  
let fill_poly ps o =
  let () = Graphics.fill_poly (Array.map o.shift ps) in
  o
  
let fill_ellipse point rx ry o =
  let x, y = o.shift point in
  let () = Graphics.fill_ellipse x y rx ry in
  o

let fill_circle ((x, y) as point) r o =
  let x, y = o.shift point in
  let () = Graphics.fill_circle x y r in
  o

let moveto point o =
  let x, y = o.shift point in
  let () = Graphics.moveto x y in
  o

let lineto point o =
  let x, y = o.shift point in
  let () = Graphics.lineto x y in
  o

module Image = struct
  let draw img point o =
    let x, y = o.shift point in
    let () = Graphics.draw_image img x y in
    o
  
  let blit img point o =
    let x, y = o.shift point in
    Graphics.blit_image img x y
  
  let get point1 point2 o =
    let x1, y1 = o.shift point1
    and x2, y2 = o.shift point2 in
    Graphics.get_image x1 y1 x2 y2
    
    let create = Graphics.create_image
    let dump = Graphics.dump_image
    let make = Graphics.make_image
  end


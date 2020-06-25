module Coord = struct
  type t = int * int

  module Map = Map.Make
    ( struct
        type nonrec t = t
                    
        let compare (x1, y1) (x2, y2) =
          match  compare y1 y2 with
          | 0 -> compare x1 x2
          | n -> n
        end
    )

  let zero = 0, 0
  let none = Int.max_int, Int.max_int
  let is_none = (=) none  
  
  let move side (x, y) =
    let dx, dy =
      match x mod 2, side with
        
      | 0, Side.Up        ->  0, -1  
      | 0, Side.LeftUp    -> -1, -1
      | 0, Side.RightUp   -> +1, -1
      | 0, Side.Down      ->  0, +1
      | 0, Side.LeftDown  -> -1,  0
      | 0, Side.RightDown -> +1,  0
                           
      | 1, Side.Up        ->  0, -1
      | 1, Side.LeftUp    -> -1,  0
      | 1, Side.RightUp   -> +1,  0
      | 1, Side.Down      ->  0, +1 
      | 1, Side.LeftDown  -> -1, +1
      | 1, Side.RightDown -> +1, +1
                           
      | _        -> assert false in
    
    x + dx,
    y + dy

  let load src  =
    let x, next = src  |> Int.load     in
    let next    = next |> Seq.skip ';' in
    let y, next = next |> Int.load     in
    (x, y), next
    
  let unload (x, y) =
    (Int.unload  x ) |> Seq.append
    (Seq.return ';') |> Seq.append
    (Int.unload  y )
  end
             
type t =
  { cytoplasms : Pigment.t Coord.Map.t;
     nucleuses : Nucleus.t Coord.Map.t;
          clot : Coord.t;
        cursor : Coord.t
  }
  
let empty =
  { cytoplasms = Coord.Map.empty;
     nucleuses = Coord.Map.empty;
          clot = Coord.none;
        cursor = Coord.none
  }
    
let is_in     i o = Coord.Map.mem i o.cytoplasms
let is_out_of i o = not (is_in i o)
   
let clot o = o.clot
let has_clot o = not (Coord.is_none o.clot)

let remove_clot o =
  { o with clot = Coord.none
  }

let set_clot i o = 
  { o with
      clot = i;
    cursor = i
  }

let cursor o = o.cursor

let set_cursor i o =
  { o with cursor = i
  }
  
let add_cursor i o =
  let () = assert (Coord.is_none o.cursor) in
  set_cursor i o
                 
let cytoplasm     i o = o.cytoplasms |> Coord.Map.find i 
let cytoplasm_opt i o = o.cytoplasms |> Coord.Map.find_opt i

let nucleus     i o = o.nucleuses |> Coord.Map.find i
let nucleus_opt i o = o.nucleuses |> Coord.Map.find_opt i
             
let set_nucleus i x o =
  let n = Coord.Map.set i x o.nucleuses in 
  { o with
    nucleuses = n;
       cursor = i
  }

let remove_nucleus i o =
  let n = Coord.Map.remove i o.nucleuses in
  { o with nucleuses = n
  }

module CharSet    = Set.Make (Char)
module CharMap    = Map.Make (Char)
module PigmentMap = Map.MakeDefault (Pigment)
module SideMap    = Map.MakeDefault (Side)
module CharsMap   = struct
  include Map.Make (CharSet)
  let find x o =
    o |> find_first (CharSet.mem x)
      |> snd
  end
                  
let swap (a, b) = (b, a)
let fst_to_char_set (chars, x) =
  (CharSet.of_list chars), x

let nucleus_pigments_draft =
  [ [ '1'; '2'; '3'; '4'; '5'; '6' ], Pigment.White;
    [ '7'; '8'; '9'; 'A'; 'B'; 'C' ], Pigment.Blue;
    [ 'D'; 'E'; 'F'; 'G'; 'H'; 'I' ], Pigment.Gray
  ] |> List.map fst_to_char_set
          
let nucleus_gazes_draft =
  [ [ '1'; '7'; 'D' ], Side.Up;
    [ '2'; '8'; 'E' ], Side.LeftUp;
    [ '3'; '9'; 'F' ], Side.RightUp;
    [ '4'; 'A'; 'G' ], Side.Down;
    [ '5'; 'B'; 'H' ], Side.LeftDown;
    [ '6'; 'C'; 'I' ], Side.RightDown
  ] |> List.map fst_to_char_set

let cytoplasms_draft =
  [ 'W', Pigment.White;
    'B', Pigment.Blue;
    'G', Pigment.Gray
  ]
  
let chars_to_nucleus_pigment =
  nucleus_pigments_draft
    |> CharsMap.of_bindings
  
let chars_to_nucleus_gaze =
  nucleus_gazes_draft
    |> CharsMap.of_bindings

let char_to_cytoplasm =
  cytoplasms_draft
    |> CharMap.of_bindings
  
let nucleus_pigment_to_chars =
  nucleus_pigments_draft
    |> List.map swap
    |> PigmentMap.of_bindings
  
let nucleus_gaze_to_chars =
  nucleus_gazes_draft
    |> List.map swap
    |> SideMap.of_bindings

let cytoplasm_to_char =
  cytoplasms_draft
    |> List.map swap
    |> PigmentMap.of_bindings

let load src = 
  let load_hex_grid parse src =
    let rec load x y (acc, next) =
      match next () with
      | Seq.Nil -> assert false
      | Seq.Cons (v, next') ->
         ( match v with
           | '0' -> (acc, next') |> load (succ x) y
           | ';' -> (acc, next') |> load 0 (succ y) 
           | ',' -> (acc, next )
           | chr -> let item = parse chr in
                    let acc  = Coord.Map.add (x, y) item acc in
                    (acc, next') |> load (succ x) y
         ) in
    load 0 0 (Coord.Map.empty, src) 

  and parse_cytoplasm c = CharMap.find c char_to_cytoplasm
  and parse_nucleus   c =
    Nucleus.make
      (CharsMap.find c chars_to_nucleus_pigment)
      (CharsMap.find c chars_to_nucleus_gaze) in
  
  let cytoplasms, src = src |> load_hex_grid parse_cytoplasm in
  let             src = src |> Seq.skip ',' in
  let nucleuses,  src = src |> load_hex_grid parse_nucleus in
  let             src = src |> Seq.skip ',' in
  let clot,       src = src |> Coord.load   in
  let             src = src |> Seq.skip ',' in
  let cursor,     src = src |> Coord.load   in
  let             src = src |> Seq.skip ',' in
  
  { cytoplasms;
    nucleuses;
    clot;
    cursor
  },
  src

let unload o =
  let cytoplasm_to_char x =
    PigmentMap.find x cytoplasm_to_char 
  and nucleus_to_char x =
    CharSet.choose @@
    CharSet.inter
      (PigmentMap.find Nucleus.(x.pigment) nucleus_pigment_to_chars)
      (SideMap.find    Nucleus.(x.gaze)    nucleus_gaze_to_chars)
    
  and map f src =
    let rec map x y next () =
      match next () with
      | Seq.Cons (((_, y'), _), _) when y' <> y ->
         Seq.Cons (';', (map 0 (succ y) next))
        
      | Seq.Cons (((x', _), _), _) when x' <> x ->
         Seq.Cons ('0', (map (succ x) y next))
        
      | Seq.Cons ((_, v), next) ->
         Seq.Cons ((f v), (map (succ x) y next))
        
      | Seq.Nil -> Seq.Nil in
    map 0 0 src in
  
  [ o.cytoplasms |> Coord.Map.to_seq
                 |> map cytoplasm_to_char;
     o.nucleuses |> Coord.Map.to_seq
                 |> map nucleus_to_char;
          o.clot |> Coord.unload;
        o.cursor |> Coord.unload;

  ] |> List.map ((Fun.flip Seq.append) (Seq.return ','))
    |> List.fold_left Seq.append Seq.empty 

module Builder = struct
  type nonrec t = t * Coord.t
                
  let empty =
    empty, Coord.zero

  let add_cytoplasm x (o, i) =
    let c = Coord.Map.add i x o.cytoplasms in
    { o with cytoplasms = c }, i

  let add_nucleus pigment gaze (o, i) =
    let x = Nucleus.make pigment gaze in
    let n = Coord.Map.add i x o.nucleuses in
    { o with nucleuses = n }, i

  let set_cursor (o, i) =
    set_cursor i o, i

  let move_coord direction (o, i) =
    o, Coord.move direction i

  let product (o, _) =
    o

  end

module OfTissue (Tissue : module type of Tissue) = struct

  module CharSet    = Sat.Make (Char)
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
      |> CharMap.of_bindings
  
  let tissue_of_string str = 
    let parse_hex_grid ~parse ~add ~src =
      let n = String.length src in
      let rec parse x y i acc =
        if i = n then acc else
          ( match src.[i] with
            | '0' -> parse (succ x) y acc 
            | ';' -> parse 0 (succ y) acc
            | chr -> parse (succ x) y (add (x, y) (parse chr) acc)
          ) (succ i) in
      parse 0 0 0
    and parse_cytoplasm c = CharMap.find c char_to_cytoplasm
    and parse_nucleus   c =
      Nucleus.{
        pigment = CharsMap.find c chars_to_nucleus_pigment;
           gaze = CharsMap.find c chars_to_nucleus_gaze
      } in

    match String.split_on_char '.' str with
    | cytoplasms_src :: nucleuses_src :: [] ->
       Tissue.empty
         |> parse_hex_grid ~src: cytoplasms_src
                         ~parse: parse_cytoplasm
                           ~add: Tissue.set_cytoplasm      
         |> parse_hex_grid ~src: nucleuses_src
                         ~parse: parse_nucleus
                           ~add: Tissue.set_nucleus
    | _ -> assert false

  let tissue_to_string tissue =
    
    
  end

module type S = sig
  type t
  val load   : char Seq.t -> (t * char Seq.t) 
  val to_seq : t -> char Seq.t
  end

module OfTissue (Tissue : module type of Tissue) = struct

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
  
  let load seq = 
    let load_hex_grid parse add =
      let rec load x y (acc, next) =
        match next () with
        | Seq.Nil -> assert false
        | Seq.Cons (v, next) ->
           ( match v with
             | '0' -> (acc, next) |> load (succ x) y
             | ',' -> (acc, next) |> load 0 (succ y) 
             | '.' -> (acc, next)
             | chr -> let item = parse chr in
                      let acc  = add (x, y) item acc in
                      (acc, next) |> load (succ x) y
           ) in load 0 0

    and parse_cytoplasm c = CharMap.find c char_to_cytoplasm
    and parse_nucleus   c =
      Nucleus.make
        (CharsMap.find c chars_to_nucleus_pigment)
        (CharsMap.find c chars_to_nucleus_gaze) in

    (Tissue.empty, seq)
       |> load_hex_grid parse_cytoplasm Tissue.add_cytoplasm      
       |> load_hex_grid parse_nucleus   Tissue.set_nucleus

  let to_seq tissue =
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
           Seq.Cons (',', (map 0 (succ y) next))
          
        | Seq.Cons (((x', _), _), _) when x' <> x ->
           Seq.Cons ('0', (map (succ x) y next))
          
        | Seq.Cons ((_, v), next) ->
           Seq.Cons ((f v), (map (succ x) y next))
          
        | Seq.Nil ->
           Seq.Cons ('.', Seq.empty) in
      map 0 0 src in
    Seq.append
      (tissue |> Tissue.cytoplasms
              |> map cytoplasm_to_char)
      (tissue |> Tissue.nucleuses
              |> map nucleus_to_char)
  end

module Make (Prototypes : IMAGE_PROTOTYPES.T) = struct

    module type PROTO = IMAGE_PROTOTYPE.T
                    
    type t = { commands : Graphics.image lazy_t array;
                 points : Graphics.image lazy_t array;
             }

    let dots_count = 6
    let dots_index =
      Data.DotsOfDice.(
        function | OOOOOO -> 0
                 | OOOOO -> 1
                 | OOOO -> 2
                 | OOO -> 3
                 | OO -> 4
                 | O -> 5
      )

    let command_index =
      Data.( Command.(
        function | Nope                       -> 0
                 | Move                       -> 1
                 | Pass                       -> 2
                 | Turn Hand.Left             -> 3
                 | Turn Hand.Right            -> 4
                 | Replicate Relation.Direct  -> 5
                 | Replicate Relation.Inverse -> 6
                 | End                        -> 7
                 | Declare x                  -> 8 + (dots_index x)
                 | Call x                     -> 8 +  dots_count
                                                   + (dots_index x)
      ))
      
    let mode_index =
      Data.RuntimeMode.(
        function | Run
                 | RunNext -> 0
                 | GoTo _
                 | Return  -> 1
      )
                        
    let image_of_prototype color_of_char prototype =
      lazy ( let module Prototype = (val prototype : PROTO) in
             
             let lines  = Lazy.force Prototype.matrix in
             let width  = Array.length lines
             and height = String.length lines.(0) in  
             
             let parse y x   = color_of_char lines.(y).[x] in
             let parse_row y = Array.init height (parse y) in
             let matrix      = Array.init width  parse_row in

             Canvas.Image.make matrix
           )
      
    let make color_scheme =
      let commands_images =
        let module ProtoAct = Prototypes.X54.Act in
        let module ColorScheme = ColorScheme.ForCommand in
        let module ProtoDots = Prototypes.X54.DotsOfDice in
        let dots_of_dice_prototypes =
          [ (module ProtoDots.OOOOOO : PROTO);
            (module ProtoDots.OOOOO);
            (module ProtoDots.OOOO);
            (module ProtoDots.OOO);
            (module ProtoDots.OO);
            (module ProtoDots.O)
          ]
        in
        [ ( let char_map =
              ColorScheme.map_for_act color_scheme in
            [ (* 00 *) (module ProtoAct.Nope : PROTO);
              (* 01 *) (module ProtoAct.Move);
              (* 02 *) (module ProtoAct.Pass);
              (* 03 *) (module ProtoAct.TurnLeft);
              (* 04 *) (module ProtoAct.TurnRight);
              (* 05 *) (module ProtoAct.ReplicateDirect); 
              (* 06 *) (module ProtoAct.ReplicateInverse)
            ] |> List.map (image_of_prototype char_map)
          );
          
          ( let char_map =
              ColorScheme.map_for_end color_scheme in
            [ (* 07 *) (module Prototypes.X54.End : PROTO)
              |> image_of_prototype char_map
            ]
          );

          ( let char_map =
              ColorScheme.map_for_declare color_scheme in
            (* 08 - 13 *) dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          );

          ( let char_map =
              ColorScheme.map_for_call color_scheme in
            (* 14 - 19 *) dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          )
        ]
        |> List.concat
        |> Array.of_list
        
      and call_stack_points_images =
        let module ColorScheme = ColorScheme.ForCallStackPoint in
        let module ProtoDots = Prototypes.X20.DotsOfDice in
        let dots_of_dice_prototypes =
          [ (module ProtoDots.OOOOOO : PROTO);
            (module ProtoDots.OOOOO);
            (module ProtoDots.OOOO);
            (module ProtoDots.OOO);
            (module ProtoDots.OO);
            (module ProtoDots.O)
          ]
        in
        [ ( let char_map =
              ColorScheme.map_for_run color_scheme in
            dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          );
          
          ( let char_map =
              ColorScheme.map_for_find color_scheme in
            dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          );
        ]
        |> List.concat
        |> Array.of_list
      in
      { commands = commands_images;
          points = call_stack_points_images
      }
      
    module Command = struct
        let get_for x o = 
          Lazy.force o.commands.(command_index x) 
      end

    module CallStackPoint = struct
        let get_for x y o = 
          Lazy.force o.points.(
            (dots_index x) + (mode_index y) * dots_count)
      end
  end

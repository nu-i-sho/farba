open CONTRACTS
open Data
   
module Make (Prototypes : PROTOIMAGES_STORAGE.T) = struct

    module type PROTO = PROTOIMAGE.T
                    
    type t = { commands : Graphics.image lazy_t array;
                 points : Graphics.image lazy_t array;
             }

    let dots_index    = DotsOfDice.index_of 
    let command_index = CommandExt.index_of
    let mode_index    =
      RuntimeMode.(
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
        let module ColorScheme = ColorScheme.Command in
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
        [ ( let char_map = ColorScheme.act color_scheme in
            [ (* 0 *) (module ProtoAct.Nope : PROTO);
              (* 1 *) (module ProtoAct.Move);
              (* 2 *) (module ProtoAct.Pass);
              (* 3 *) (module ProtoAct.TurnLeft);
              (* 4 *) (module ProtoAct.TurnRight);
              (* 5 *) (module ProtoAct.ReplicateDirect); 
              (* 6 *) (module ProtoAct.ReplicateInverse)
            ] |> List.map (image_of_prototype char_map)
          );
          
          ( let char_map = ColorScheme.finish color_scheme in
            [ (* 7 *) (module Prototypes.X54.End : PROTO)
              |> image_of_prototype char_map
            ]
          );

          ( let char_map = ColorScheme.declare color_scheme in
            (* 8 - 13 *) dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          );

          ( let char_map = ColorScheme.call color_scheme in
            (* 14 - 19 *) dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          )
        ]
        |> List.concat
        |> Array.of_list
        
      and call_stack_points_images =
        let module ColorScheme = ColorScheme.CallStackPoint in
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
        [ ( let char_map = ColorScheme.run color_scheme in
            dots_of_dice_prototypes
              |> List.map (image_of_prototype char_map)
          );
          
          ( let char_map = ColorScheme.find color_scheme in
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
            (dots_index x) + (mode_index y) * DotsOfDice.count)
      end
  end

open CONTRACTS
module Make (Prototypes : PROTOIMAGES_STORAGE.T) = struct
    open Data

    module type DOTS = DOTS_OF_DICE_NODE.MAKE (PROTOIMAGE).T
    module ProtoDotsMap = Tools.DotsOfDiceNodeMap.Make (PROTOIMAGE)
  
    type result_t = Image.t
    type t = { command_colors : CommandColorScheme.t;
                 point_colors : CallStackPointColorScheme.t
             }

    let make command_colors point_colors =
      { command_colors;
        point_colors
      }

    module Command = struct
        module X54  = Prototypes.X54

        let get command o =
          let prototype =
            let open Command in
            match command with
            | Declare dots
            | Call    dots    -> (module X54.DotsOfDice : DOTS)
                                    |> ProtoDotsMap.get dots
            | Nope            -> (module X54.Act.Nope)
            | Move            -> (module X54.Act.Move)
            | Pass            -> (module X54.Act.Pass)
            | Turn Hand.Left  -> (module X54.Act.TurnLeft)
            | Turn Hand.Right -> (module X54.Act.TurnRight)
            | Replicate Relation.Direct
                              -> (module X54.Act.ReplicateDirect)
            | Replicate Relation.Inverse
                              -> (module X54.Act.ReplicateInverse)
            | End             -> (module X54.End)
              
          and color_map =
            let open CommandColorScheme in
            let open CommandKind in
              
            match CommandExt.kind_of command with
            | Act     -> o.command_colors.act_map 
            | Call    -> o.command_colors.call_map
            | Declare -> o.command_colors.declare_map
            | End     -> o.command_colors.end_map in
          
          Image.of_prototype color_map prototype
      end

    module CallStackPoint = struct
        module X20 = Prototypes.X20
                 
        let rec get dots mode o =
          let prototype = (module X20.DotsOfDice : DOTS)
                             |> ProtoDotsMap.get dots
          and color_map =
            let open CallStackPointColorScheme in
            match RuntimeModeExt.kind_of mode with
            | RuntimeModeKind.Find -> o.point_colors.find_map
            | RuntimeModeKind.Run  -> o.point_colors.run_map in
          
          Image.of_prototype color_map prototype
      end
  end

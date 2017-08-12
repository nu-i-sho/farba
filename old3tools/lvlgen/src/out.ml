type t = {  channel : out_channel;
             config : Config.t;
         }

let start file_name config =
  {  channel = open_out file_name;
      config
  }

let put_none o =
  o
  
let put str o =
  let () = output_string o.channel str in
  o

let put_all strs o =
  let put o str = put str o in
  List.fold_left put o strs

let put_change_dir_to dir =
  put_all [ "cd "; dir; Const.end_line ]

let put_remove dir o =
  o |> put_all [ "rm -R "; dir; Const.end_line ]

let put_make dir o =
  o |> put_all [ "mkdir "; dir; Const.end_line ]
    
let finish o =
  close_out o.channel

type t =
  { processor : Processor.t;
     level_id : int;
      session : string
  }
  
module Error = struct
  module OpenNew = struct
    type t =
      | Level_is_missing
      | Level_is_unavailable
    end

  module Restore = struct
    type t =
      | Backup_not_found
      | Backup_is_corrupted
    end
       
  module Save = struct
    type t =
      | Name_is_empty
    end

  module SaveAs = struct
    type t =
      | Name_is_empty
      | File_exists
    end
  end
       
let open_new level_id =
  try let level = Levels.get level_id Levels.std in
      let p = Processor.make level.tissue Source.empty in
      Result.Ok { processor = p;
                   level_id = level.id;
                    session = "" 
                }
      
  with Invalid_argument _ ->
      Result.Error Error.OpenNew.Level_is_missing

let path level_id name = Config.backups_dir
                       ^ Config.dir_separator
                       ^ (string_of_int level_id)
                       ^ Config.dir_separator
                       ^ name
                       ^ Config.backup_ext
      
let restore level_id name =
  Result.bind
    ( try Result.Ok (open_in (path level_id name))
      with Not_found -> Result.Error Error.Restore.Backup_not_found
    )
    ( fun backup ->
      try let p : Processor.t = Marshal.from_channel backup in
          let () = close_in backup in
          Result.Ok { processor = p;
                       level_id;
                        session = name
                    }
      with End_of_file | Failure _ ->
          let () = close_in_noerr backup in
          Result.Error Error.Restore.Backup_is_corrupted
    )

let save o =
  if o.session = "" then
    Result.Error Error.Save.Name_is_empty else
    let file = open_out (path o.level_id o.session) in
    let () = Marshal.to_channel file o.processor [] in
    let () = close_out file in
    Result.Ok o

let save_force name o =
  save { o with session = name }

let save_as name o =
  let path = path o.level_id name in
  if Sys.file_exists path then
    Result.Error Error.SaveAs.File_exists else
    match save_force name o with
    | (Result.Error Error.Save.Name_is_empty) -> 
       Result.Error Error.SaveAs.Name_is_empty
    | (Result.Ok _) as result ->
       result 

let () =
  let () = Callback.register "Program.open_new"   open_new   in
  let () = Callback.register "Program.restore"    restore    in
  let () = Callback.register "Program.save"       save       in
  let () = Callback.register "Program.save_as"    save_as    in
  let () = Callback.register "Program.save_force" save_force in
  ()

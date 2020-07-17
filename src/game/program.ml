type t =
  { processor : Processor.t;
     level_id : int;
      session : string
  }

module Error = struct
  module OpenNew = struct
    type t = [ `LEVEL_IS_MISSING
             | `LEVEL_IS_UNAILABLE
             ]
    end

  module AccessFile = struct
    type t = [ `PERMISSION_DENIED
             ]
    end
       
  module Restore = struct
    type t = [  AccessFile.t
             | `BACKUP_NOT_FOUND
             | `BACKUP_IS_CORRUPTED
             ]
    end
       
  module Save = struct
    type t = [  AccessFile.t
             | `NAME_IS_EMPTY
             ]
    end

  module SaveAs = struct
    type t = [  Save.t
             | `FILE_ALREADY_EXIST
             ]
    end
       
  type t =
    [ OpenNew.t
    | Restore.t
    | AccessFile.t
    | Save.t
    | SaveAs.t
    ]
  end
       
let open_new level_id =
  try let level = Levels.get level_id Levels.std in
      let p = Processor.make level.tissue Source.empty in
      Result.Ok { processor = p;
                   level_id = level.id;
                    session = "" 
                }
      
  with Invalid_argument _ ->
      Result.Error `LEVEL_IS_MISSING

let backup_dir_path level_id =
  String.concat "" [ Config.backups_dir;
                     Config.dir_separator;
                     string_of_int level_id;
                   ] 
  
let backup_file_path level_id name =
  String.concat "" [ backup_dir_path level_id;   
                     Config.dir_separator;
                     name;
                     Config.backup_ext;
                   ] 

let restore level name =
  try let backup = open_in (backup_file_path level name) in
  try let state : Processor.t = Marshal.from_channel backup in
      let () = close_in backup
       in Result.Ok { processor = state;
                       level_id = level;
                        session = name
                    }
  with | End_of_file | Failure _             ->
          let () = close_in_noerr backup in
          Result.Error `BACKUP_IS_CORRUPTED
  with | Not_found                           ->
          Result.Error `BACKUP_NOT_FOUND
       | Unix.Unix_error (Unix.EACCES, _, _) ->
          Result.Error `PERMISSION_DENIED

let save o =
  try if o.session <> "" then
        let file = open_out (backup_file_path o.level_id o.session) in
        let () = Marshal.to_channel file o.processor [] in
        let () = close_out file in
        Result.Ok o else
        Result.Error `NAME_IS_EMPTY
  with Unix.Unix_error (Unix.EACCES, _, _) ->
        Result.Error `PERMISSION_DENIED

let save_force name o =
  save { o with session = name }

let create_dir_if_missing dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o640 else
    ()
  
let save_as name o =
  try let () = create_dir_if_missing Config.backups_dir in
      let () = create_dir_if_missing (backup_dir_path o.level_id) in
      if Sys.file_exists (backup_file_path o.level_id name) then
        Result.Error `FILE_ALREADY_EXIST else
        save_force name o
  with Unix.Unix_error (Unix.EACCES, _, _) ->
        Result.Error `PERMISSION_DENIED 

let () =
  let () = Callback.register "Program.open_new"   open_new   in
  let () = Callback.register "Program.restore"    restore    in
  let () = Callback.register "Program.save"       save       in
  let () = Callback.register "Program.save_as"    save_as    in
  let () = Callback.register "Program.save_force" save_force in
  ()

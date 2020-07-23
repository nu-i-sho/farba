type t =
  { processor : Processor.t;
     level_id : int;
      session : string
  }

module File = struct
  module Error = struct
    module OpenNew = struct
      type t = [ `Level_is_missing
               | `Level_is_unavailable
               ]
      end

    module Access = struct
      type t = [ `Permission_denied
               ]
      end
       
    module Restore = struct
      type t = [  Access.t
               | `Backup_not_found
               | `Backup_is_corrupted
               ]
      end
       
    module Save = struct
      type t = [  Access.t
               | `Name_is_empty
               ]
      end

    module SaveAs = struct
      type t = [  Save.t
               | `File_already_exists
               ]
      end
       
    type t =
      [ OpenNew.t
      | Restore.t
      | Access.t
      | Save.t
      | SaveAs.t
      ]
    end
       
  let open_new level =
    try let level = Levels.get level Levels.std in
        let p = Processor.make level.tissue Source.empty in
        Result.Ok { processor = p;
                     level_id = level.id;
                      session = "" 
                  }  
    with Invalid_argument _ ->
        Result.Error `Level_is_missing

  let backup_dir_path level =
    String.concat "" [ Config.backups_dir;
                       Config.dir_separator;
                       string_of_int level;
                     ] 
  
  let backup_file_path level name =
    String.concat "" [ backup_dir_path level;   
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
            Result.Error `Backup_is_corrupted
    with | Not_found                           ->
            Result.Error `Backup_not_found
         | Unix.Unix_error (Unix.EACCES, _, _) ->
            Result.Error `Permission_denied

  let save o =
    try if o.session <> "" then
          let file = open_out (backup_file_path o.level_id o.session) in
          let () = Marshal.to_channel file o.processor [] in
          let () = close_out file in
          Result.Ok o else
          Result.Error `Name_is_empty
    with Unix.Unix_error (Unix.EACCES, _, _) ->
          Result.Error `Permission_denied

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
          Result.Error `File_already_exists else
          save_force name o
    with Unix.Unix_error (Unix.EACCES, _, _) ->
          Result.Error `Permission_denied 

  end

module Debug = struct
  let step o =
    match Processor.step o.processor with
    | Some p -> Some { o with processor = p }
    | None   -> None
  end

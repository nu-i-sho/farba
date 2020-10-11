type t =
  { tissue_build : Tissue.Constructor.Command.t list;
            tape : Tape.t
  }

let make tissue_build tape =
  { tissue_build;
    tape
  }
  
let dir_path level =
  String.concat "" [ Config.backups_dir;
                     Config.dir_separator;
                     string_of_int level;
                   ]

let file_path level name =
  String.concat "" [ dir_path level;   
                     Config.dir_separator;
                     name;
                     Config.backup_ext;
                   ]

let create_dir_if_missing dir =
  if not (Sys.file_exists dir) then
    Unix.mkdir dir 0o640 else
    ()
  
exception Is_corrupted of string
exception Not_found of string
exception Permission_denied of string
                         
let restore level name =
  let path = file_path level name in
  try let backup = open_in path in
  try let result : t = Marshal.from_channel backup in
      let () = close_in backup in
      result

  with | End_of_file | Failure _             ->
          let () = close_in_noerr backup in
          raise (Is_corrupted path)
          
  with | Not_found _                         ->
          raise (Not_found path)
         
       | Unix.Unix_error (Unix.EACCES, _, _) ->
          raise (Permission_denied path)

let save level name o =
  try let () = create_dir_if_missing Config.backups_dir in
      let () = create_dir_if_missing (dir_path level) in
      let file = open_out (file_path level name) in
      let () = Marshal.to_channel file o [] in
      let () = close_out file in
      ()
      
  with Unix.Unix_error (Unix.EACCES, _, path) ->
    raise (Permission_denied path)

let exists level name =
  Sys.file_exists (file_path level name)

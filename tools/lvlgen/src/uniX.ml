let mkdir dir = 
  let parent_dir = Unix.getcwd () in 
  let () = Unix.chdir Const.dir_up
  and parent = Unix.opendir parent_dir in
  
  let rec exists () =
    try if (Unix.readdir parent) = dir then 
	  true else
	  exists () 
    with End_of_file -> 
      false
  in

  let exists = exists () 
  and () = Unix.chdir parent_dir
  and () = Unix.closedir parent
  and () = ignore (Unix.umask 0o000) in

  if exists then 
    Unix.chmod dir 0o777 else 
    Unix.mkdir dir 0o777

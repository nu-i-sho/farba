let run () =
  let () = Unix.chdir "../../../"
  and farba_dir = Unix.getcwd ()
  and () = Unix.chdir "tools/lvlpack/bin/" in 
  Lvlpack.generate farba_dir "1.ml" 3

let () = run ()

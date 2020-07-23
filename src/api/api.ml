let () =
  Callback.(
    let () = register "File.open_new"   Core.Api.File.open_new   in
    let () = register "File.restore"    Core.Api.File.restore    in
    let () = register "File.save"       Core.Api.File.save       in
    let () = register "File.save_as"    Core.Api.File.save_as    in
    let () = register "File.save_force" Core.Api.File.save_force in
    ()
  )

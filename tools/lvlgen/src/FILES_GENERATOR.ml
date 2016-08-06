module type T = sig
  val generate_levels_files : Config.t -> unit
  val generate_make_file    : Config.t -> CompilerConfig.t -> unit
end

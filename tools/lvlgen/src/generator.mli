module Make (FilesGenerator : FILES_GENERATOR.T) : sig
  val generate : Config.t -> Compiler.t list -> unit
end

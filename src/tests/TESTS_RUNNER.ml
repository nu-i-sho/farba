module type T = sig
  type t
  type source_t

  val make : (TestMessage.t -> unit) -> t
  val run  : source_t -> t -> t
end

module FOR_TEST = struct
  module type T = T with type 
	source_t = (module TEST.T)
end

module FOR_TESTS_SET = struct
  module type T = T with type 
	source_t = (module TESTS_SET.T)
end

module FOR_TESTS_SESSION = struct
  module type T = T with type 
	source_t = (module TESTS_SESSION.T)
end

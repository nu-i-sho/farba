module type T = sig
  type output_t
  type message_t
  type testSession_t

  val run  : testSession_t -> output:output_t -> output_t
  val exec : testSession_t -> message_t list
end

module type MAKE_T = functor
    (Output : OBSERVER.T with type message_t = TestMessage.t) ->
      T with type output_t = Output.t 
         and type message_t = TestMessage.t
	 and type testSession_t = (module TESTS_SESSION.T)

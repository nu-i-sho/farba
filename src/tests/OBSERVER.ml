module type T = sig
  type t
  type message_t
  
  val send : message_t -> t -> t
end

module type MAKE_T = functor
    (Message : T.T) ->
      T with type message_t = Message.t 

module type T = sig
  type arg_t
  exception Error of arg_t
end

module type MAKE_T = 
    functor (Arg : T.T) -> 
      T.T with type arg_t = Arg.t

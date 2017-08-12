module Make (Arg : T.T) = struct
  type arg_t = Arg.t
  exception Error of arg_t
end

module OfChar = Make (Char)

module Make (Arg : T.T) = struct
  exception Error of Arg.t
end

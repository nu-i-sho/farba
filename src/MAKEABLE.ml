module type T = sig
  include T.T
  val make : unit -> t
end
      

module type T = sig
    include RUNTIME.T
    val statistics : t -> Data.Statistics.t
  end

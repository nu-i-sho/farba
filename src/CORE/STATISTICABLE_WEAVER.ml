module type T = sig
    include WEAVER.T
    val statistics : t -> Data.Statistics.Weaver.t
  end

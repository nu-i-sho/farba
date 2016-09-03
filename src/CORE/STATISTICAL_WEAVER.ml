module type T = sig
    include WEAVER.T
    val statistics : t -> Data.WeaverStatistics.t
  end

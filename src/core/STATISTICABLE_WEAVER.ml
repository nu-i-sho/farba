module type T = sig
    include WEAVER.T
    val statistics : t -> WeaverStatistics.t
  end

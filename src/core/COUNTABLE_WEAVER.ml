module type T = sig
    include WEAVER.T
    val acts_statistics : t -> Data.Statistics.OfActs.t
  end

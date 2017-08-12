module type T = sig

    include RUNTIME.T
    type counter_t
    val counter_of : t -> counter_t

  end

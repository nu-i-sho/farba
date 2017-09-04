module type T = sig
    include Map.S

    val set        : key -> 'e -> 'e t -> 'e t
    val item       : key -> 'e t -> 'e
    val maybe_item : key -> 'e t -> 'e option
  end

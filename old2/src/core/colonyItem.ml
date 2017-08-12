include Shared.ColonyItem

let of_char = 
  function | ' ' -> Empty
           | chr -> Cytoplasm (Pigment.of_char chr)

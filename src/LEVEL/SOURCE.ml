module type T = sig

    type flora
    type fauna
  
    val height : int
    val width  : int
    val active : int * int
    val flora  : flora
    val fauna  : fauna

  end

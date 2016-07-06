module type T = sig 
    MATRIX.T with type e = Pigment.t
    val load : SourceFor.Flora.t -> t
end

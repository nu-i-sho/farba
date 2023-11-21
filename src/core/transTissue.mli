module Make :
  functor (Original : TISSUE.RESOLVABLE.T) ->
    TISSUE.TRANSACTIONAL.T with type original_t := Original.t

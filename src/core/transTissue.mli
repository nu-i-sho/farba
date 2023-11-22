module Make :
  functor (Original : TISSUE.T) ->
    TISSUE.TRANSACTIONAL.T with type original_t := Original.t

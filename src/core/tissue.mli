include TISSUE.T

module ReadOnly : sig
  module Cover :
    functor (Original : TISSUE.READ_ONLY.T) ->
    functor (Seed : TISSUE.READ_ONLY.COVER_SEED.T
             with type original_t := Original.t) ->
    TISSUE.READ_ONLY.T with type t = Seed.t
  end

module Cover :
  functor (Original : TISSUE.T) ->
  functor (Seed : TISSUE.COVER_SEED.T
           with type original_t := Original.t) ->
  TISSUE.T with type t = Seed.t

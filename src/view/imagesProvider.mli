module Make (Prototypes : CONTRACTS.PROTOIMAGES_STORAGE.T) : sig
    include IMAGES_PROVIDER.T with type result_t = Image.t

    val make : CommandColorScheme.t
            -> CallStackPointColorScheme.t
            -> t
  end

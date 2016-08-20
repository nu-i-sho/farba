module Make (Prototypes : CONTRACTS.PROTOIMAGES_STORAGE.T) : sig
    type t
    type result_t = (Image.t, t) StateUpdatableResult.t           
    include IMAGES_STORAGE.T with type result_t := result_t
                              and type t := t
  end

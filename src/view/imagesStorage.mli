module Decorate (Provider : IMAGES_PROVIDER.T
                              with type result_t = Image.t) : sig
    type t
    type result_t = (Image.t, t) StateUpdatableResult.t           
    include IMAGES_PROVIDER.T with type result_t := result_t
                              and type t := t
    val decorate : Provider.t -> t
  end

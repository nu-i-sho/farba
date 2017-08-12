module Hels : sig
    include NUCLEUS.T with type t = Shared.Nucleus.Hels.t
  end

module Cancer : sig
    include NUCLEUS.T with type t = Shared.Nucleus.Cancer.t
  end

include NUCLEUS.T with type t = Shared.Nucleus.t

type t

val empty     : t
val kind_of   : t -> Gene.OfSpirit.Kind.t
val energy_of : t -> Gene.OfSpirit.Energy.t list
val step      : t -> t
val active_breadcrumb_of
              : t -> Gene.OfSpirit.Energy.t

type t

val empty     : t
val kind_of   : t -> Gene.OfSpirit.Kind.t
val energy_of : t -> Gene.OfSpirit.Breadcrumb.t list
val step      : t -> t
val active_breadcrumb_of
              : t -> Gene.OfSpirit.Breadcrumb.t

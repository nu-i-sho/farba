type t = | Moved of Crumb.t * Crumb.t
         | Merged of Crumb.t * Crumb.t
         | Splited of Crumb.t * Crumb.t

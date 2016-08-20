type t = | Find
         | Run
                 
val index_of : t -> int
val compare  : t -> t -> int

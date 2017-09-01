type 'e t = 'e * ('e list)

val head    : 'e t -> 'e
val tail    : 'e t -> 'e t
val last    : 'e t -> 'e
val to_list : 'e t -> 'e list
val of_list : 'e list -> 'e t   
  
val assoc     : 'k -> ('k * 'v) t -> 'v 
val mem_assoc : 'k -> ('k * 'v) t -> bool

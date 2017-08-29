type 'e t = 'e * ('e list)

val head    : 'e t -> 'e
val tail    : 'e t -> 'e t
val to_list : 'e t -> 'e list
val of_list : 'e list -> 'e t

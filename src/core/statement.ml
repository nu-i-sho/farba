type ('p, 'c, 'd) t =
  | Perform of 'p
  | Call    of 'c
  | Declare of 'd

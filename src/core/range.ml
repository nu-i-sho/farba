let rec make first =
  function | 0     -> []
           | count -> first :: (make (first + 1) (count - 1))

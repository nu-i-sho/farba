type 'a t = ('a -> unit)

let make (observer : 'a t) = observer
let next event observer =
    let () = observer event in
    observer

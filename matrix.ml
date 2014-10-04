module Make(Elt : Iemptible.T) = struct
  class matrix width hight = object(self)

    val mutable cells : Elt.t array =
      Array.create (width * hight) Elt.empty

    method private index (x, y) =
      y * hight + x

    method width = width
    method hight = hight

    method get p =
      let i = self#index p in
      cells.(i)

    method set p v =
      let i = self#index p in
      cells.(i) <- v
  end

  class qmatrix_o size o = object
    inherit qmatrix size as super

    method set p v = 
      let () = super#set p v in
      o p v
  end

  type t   = qmatrix

  let width_of b = b#width
  let hight_of b = b#width
  let get b      = b#get
  let set b      = b#set

  let make size = 
    new qmatrix size
 
  let make_o size ~observer:o =
    new qmatrix_o size o
end

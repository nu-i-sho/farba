module Make (Crumbs : BREADCRUMBS.T) 
             (Frame : CANVAS.T)
           (Pointer : PROGRAM_POINTER.T)
           (DotsImg : IMG.DOTS_OF_DICE.T) = struct
    
    open Std

    type t = { current : Crumbs.t;
               hiddens : Graphics.image list;
	        buffer : Graphics.image list;
	       pointer : Pointer.t
	     } 

    let last       o = Crumbs.last o.current
    let last_place o = Crumbs.last_place o.current
    let is_empty   o = Crumbs.is_empty o.current
    let count      o = Crumbs.count o.current
    let length     o = Crumbs.length o.current
    
    let get_point ptr i = 
      let x, y = Pointer.get i ptr in
      (x + 17), 
      (y - 17)

    let print_img crumbs ptr img =
      crumbs |> Crumbs.last_place
             |> get_point ptr
             |> Frame.draw_image img

    let print crumbs ptr = 
      crumbs |> Crumbs.last
             |> DotsImg.get
             |> print_img crumbs ptr

    let new_img () = 
      Frame.create_image 20 20

    let scan_hidden crumbs ptr img =      
      crumbs |> Crumbs.last_place
             |> get_point ptr
             |> Frame.blit_image img

    let make ~breadcrumbs:b ~pointer:p =
      let h  = new_img () in 
      let () = scan_hidden b p h in
      let () = print b p in
      { current = b; 
	hiddens = [h];
	 buffer = [];
	pointer = p
      }
      
   
    let increment o = 
      let next = Crumbs.increment o.current in
      let next_h, buff = 
	match o.buffer with
        | img :: buff -> img, buff
        | []          -> new_img (), []
      in

      let () = scan_hidden next o.pointer next_h in
      let current_h :: hs = o.hiddens in
      let () = print_img o.current o.pointer current_h in
      let () = print next o.pointer in
      
      { o with hiddens = next_h :: hs;
	        buffer = current_h :: buff;
               current = next;
      }

    let decrement o =
      let next = Crumbs.decrement o.current in
      let current_h :: hs = o.hiddens in
      let () = print_img o.current 
			 o.pointer 
			 current_h 
      in

      let hiddens, buffer = 
	if (Crumbs.last_place next) = 
           (Crumbs.last_place o.current) 
	then 
	  hs, (current_h :: o.buffer) 
	else 
	  let next_h, buff = 
	    match o.buffer with
            | img :: buff -> img, buff
            | []          -> new_img (), []
	  in
	  
	  let () = scan_hidden next o.pointer next_h in
	  let () = print next o.pointer in
	  (next_h :: hs), (current_h :: buff)
      in

      { o with current = next; 
	       hiddens;
		buffer
      }
	
    let split o =
      let next = Crumbs.split o.current in
      let next_h, buffer = 
	match o.buffer with
        | img :: buff -> img, buff
        | []          -> new_img (), []
      in

      let () = scan_hidden next o.pointer next_h in
      let () = print next o.pointer in
      { o with current = next; 
	       hiddens = next_h :: o.hiddens;
	        buffer; 
      }
      
  end

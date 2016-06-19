module Make (Crumbs : BREADCRUMBS.T) 
             (Frame : CANVAS.T)
           (Pointer : PROGRAM_POINTER.T)
           (DotsImg : IMG.DOTS_OF_DICE.T) = struct
    
    open Std

    type t = { current : Crumbs.t;
               hiddens : Graphics.image list;
	       pointer : Pointer.t
	     } 

    let last       o = Crumbs.last o.current
    let last_place o = Crumbs.last_place o.current
    let is_empty   o = Crumbs.is_empty o.current
    let count      o = Crumbs.count o.current
    let length     o = Crumbs.length o.current

    let img_coords (x, y) = 
      ((x + 17, y - 17), (x + 37, y - 37))

    let print_img crumbs ptr img =
      crumbs |> Crumbs.last_place
             |> ~<| Pointer.get ptr
             |> img_coords
             |> fst
             |> Frame.draw_image img

    let print crumbs ptr = 
      crumbs |> Crumbs.last
             |> DotsImg.get
             |> print_img crumbs ptr

    let scan_hidden crumbs ptr = 
      crumbs |> Crumbs.last_place
             |> ~<| Pointer.get ptr
             |> img_coords
             |> Frame.get_image
 
    let make ~breadcrumbs:b ~pointer:p =
      let h = scan_hidden b p in
      let () = print b p in
      { current = b; 
	hiddens = [h];
	pointer = p;
      }
      
    let increment o = 
      let next = Crumbs.increment o.current in
      let next_h = scan_hidden next o.pointer in
      let current_h :: hs = o.hiddens in
      let () = print_img o.current o.pointer current_h in
      let () = print next o.pointer in
      { o with hiddens = next_h :: hs;
               current = next; 
      }

    let decrement o =
      let next = Crumbs.decrement o.current in
      let current_h :: hs = o.hiddens in
      let () = print_img o.current 
			 o.pointer 
			 current_h 
      in

      let hiddens = 
	if (Crumbs.last_place next) = 
           (Crumbs.last_place o.current) 
	then hs 
	else let next_h = scan_hidden next o.pointer in
	     let () = print next o.pointer in
	     next_h :: hs
      in

      { o with current = next; 
	       hiddens
      }
	
    let split o =
      let next = Crumbs.split o.current in
      let next_h = scan_hidden next o.pointer in
      let () = print next o.pointer in
      { o with current = next; 
	       hiddens = next_h :: o.hiddens
      }
      
  end

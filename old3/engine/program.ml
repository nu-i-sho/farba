module Make (D : DEPENDENCIES.PROGRAM.T) = struct

    open D.Core
    open Tools
    open Data

    module LineExt = ProgramLineExt
    module Line = ProgramLine
    module View = D.View.Program

    type t = {  base : Program.t;
                view : View.t;
               max_x : int
             }

    let make program view =
      let height = view |> View.height
      and width  = view |> View.width in

      let max_x = pred width  
      and base  = Program.init height width program in
      let view  =
        Line.( Value.(
          let rec init_lines y view = 
            let line = Program.line y base
            and init item x =
              ItemInit.({ value = item;
                          index = x, y;
                        }) |> View.init_item in
            
            ( match line.value with
              | Right item            -> view |> init item max_x
              | Left item             -> view |> init item 0
              | FromLeftToRight items
              | FromRightToLeft items ->
                 let rec init_line x view =
                   ( match Vector.try_get x items with
                     | Some item -> view |> init item x
                     | None      -> view
                   ) |> init_line (succ x) in
                 
                 view |> View.init_line (LineExt.kind_of line)
                      |> init_line 0
            ) |> init_lines (succ y) in
          
          view |> init_lines 0
        )) in
      
      { max_x;
        base;
        view
      }

    let update_vector_line prev_line curr_line y view =
      let rec update x view =
        ( match Vector.try_get x curr_line with
          | None           -> view
          | Some curr_item ->
             let prev_item = Vector.get x prev_line in
             if curr_item = prev_item then view else
               view |> View.update_item
                         ItemUpdate.({ previous = Some prev_item; 
                                        current = Some curr_item;
                                          index = x, y
                                     })
        ) |> update (succ x) in
      update 0 view

    let vector_of =
      Line.Value.(
        function | FromLeftToRight vector
                 | FromRightToLeft vector -> vector
                 | Left  _
                 | Right _                ->
                    failwith Fail.impossible_case
      )

    let item_of =
      Line.Value.(
        function | Left  item
                 | Right item             -> item
                 | FromLeftToRight vector
                 | FromRightToLeft vector ->   
                    failwith Fail.impossible_case
      )
      
    let succ o =
      let prev = o.base in
      let curr = Program.succ prev in
      let prev_active = Program.active_line 0 prev
      and curr_active = Program.active_line 0 curr in

      let update x y curr_item view =
        let prev_item = item_of prev_active in
        if prev_item = curr_item then view else
          view |> View.update_item
                    ItemUpdate.({ previous = Some prev_item; 
                                   current = Some curr_item;
                                     index = x, y
                                }) in
      Line.(
        let y = curr_active.index in
        if y = prev_active.index
        then match prev_active.value, curr_active.value with 
             | Value.Left  item -> view |> update 0 y item 
             | Value.Right item -> view |> update max_x y item
             | Value.FromLeftToRight curr_vector
             | Value.FromRightToLeft curr_vector
                                -> view |> update_vector_line
                                             (vector_of prev_active)
                                              curr_vector
                                              curr_active.index
        else 
             
  end

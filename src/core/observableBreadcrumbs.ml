open CONTRACTS
module Subscribe (Observer : BREADCRUMBS_OBSERVER.T) = struct
    type t = { observer : Observer.t;
                   base : Breadcrumbs.t
             }

    let subscribe observer =
      let base = Breadcrumbs.start in
      { observer =
          Observer.init
            (Breadcrumbs.top base)
            (Breadcrumbs.mode base)
             observer;
        base
      }

    let top o =
      Breadcrumbs.top o.base

    let mode o =
      Breadcrumbs.mode o.base

    let with_mode x o =
      let previous = mode o
      and base = Breadcrumbs.with_mode x o.base in
      let current = Breadcrumbs.mode o.base in
      let observer =
        Observer.update_mode previous current o.observer in
      { observer;
        base
      }

    let change_crumbs_with f o =
      let previous = top o
      and base = f o.base in
      let current = Breadcrumbs.top o.base in
      let observer =
        Observer.update_top_crumb previous current o.observer in
      { observer;
        base
      }
        
    let move  = change_crumbs_with Breadcrumbs.move
    let back  = change_crumbs_with Breadcrumbs.back
    let split = change_crumbs_with Breadcrumbs.split

  end

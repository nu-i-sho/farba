module Api = Core.OApi
type c_api
           
module Observer_for = struct
  module Cursor = struct
    type event = Api.EventsOf.Cursor.event
    type t = c_api

    module E = Core.OCursor.Event
    external turned     : E.turned_msg     -> t -> t = "on_cursor_turned"
    external moved_body : E.moved_body_msg -> t -> t = "on_cursor_moved_body"
    external moved_mind : E.moved_mind_msg -> t -> t = "on_cursor_moved_mind"
    external replicated : E.replicated_msg -> t -> t = "on_cursor_replicated"
        
    let send = function
      | E.Turned     msg -> turned     msg
      | E.Moved_body msg -> moved_body msg
      | E.Moved_mind msg -> moved_mind msg
      | E.Replicated msg -> replicated msg 
    end
  end

module Events_of = struct
  module Cursor = struct
    let subscribe c_api api =
      let obs : c_api Api.EventsOf.Cursor.observer =
        (module Observer_for.Cursor) in
      Api.EventsOf.Cursor.subscribe obs c_api api

    let unsubscribe = Api.EventsOf.Cursor.unsubscribe 
    end
  end
                    
let () =
  Callback.(
    let () = register "File.open_new"   Api.File.open_new   in
    let () = register "File.restore"    Api.File.restore    in
    let () = register "File.save"       Api.File.save       in
    let () = register "File.save_as"    Api.File.save_as    in
    let () = register "File.save_force" Api.File.save_force in
    
    let () = register "Events.Cursor.subscribe"
                       Events_of.Cursor.subscribe in
    let () = register "Events.Cursor.unsubscribe"
                       Events_of.Cursor.unsubscribe in
    ()
  )

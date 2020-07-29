include PROCESSOR.S

module EventsOf : sig
  module Cursor : OBSERV.ABLE.S
    with type t := t
     and type event = OCursor.event
     and type 'a observer = 'a OCursor.observer
     and type 'a subscription = 'a OCursor.subscription
     and module OBSERVER = OCursor.OBSERVER
  end

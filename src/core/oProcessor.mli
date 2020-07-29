include PROCESSOR.S

module EventsOf : sig
  module Cursor : OBSERV.ABLE.COPY (OCursor).S with type t = t
  end

module Make (Observable : OBSERV.ABLE.S) (Container : PACK.MAKE (Observable).S)
       : OBSERV.ABLE.COPY (Observable).S with type t = Container.t

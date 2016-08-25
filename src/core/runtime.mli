module Make (Crumbs : BREADCRUMBS.T)
            (Weaver : WEAVER.T)
                    : RUNTIME.T with type crumbs_t = Crumbs.t
                                 and type weaver_t = Weaver.t

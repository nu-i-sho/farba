type ('cmd, 'proc_exc, 'proc_dcl) t =
  | Perform of 'cmd
  | Execute of 'proc_exc
  | Declare of 'proc_dcl

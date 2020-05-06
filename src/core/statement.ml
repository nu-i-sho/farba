type ( 'perform_attachment,
       'call_attachment,
       'parameter_attachment,
       'procedure_attachment
     )
       t = | Perform   of Action.t * 'perform_attachment
           | Call      of Dots.t   * 'call_attachment
           | Parameter of Dots.t   * 'parameter_attachment
           | Procedure of Dots.t   * 'procedure_attachment

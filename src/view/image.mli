type t = Graphics.image

val of_prototype : (char -> Graphics.color)
                -> (module CONTRACTS.PROTOIMAGE.T)
                -> t

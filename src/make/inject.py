#!/usr/bin/env python3

# arg1 - file to inject
# arg2 - injection label
# arg(3..n) - lines to inject

import sys
import os

start_label = "(* inject {0} *)".format(sys.argv[2])
end_label   = "(* inject end *)"

start_label += os.linesep
end_label   += os.linesep

src = open(sys.argv[1], "r")
src_lines = src.readlines()
inject_lines = sys.argv[3:]
src.close()

src = open(sys.argv[1], "w")
skip = False

for s_line in src_lines:
    if skip:
        if s_line == end_label:
            skip = False
            src.write(s_line)
    elif s_line == start_label:
        skip = True
        src.write(s_line)
        for i_line in inject_lines:
            src.write(i_line + os.linesep)
    else:
        src.write(s_line)

src.close()

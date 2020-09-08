require 'mkmf'

$CFLAGS = "-O3 -Wall"

create_makefile('dedup/dedup')

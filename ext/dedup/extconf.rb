# frozen_string_literal: true

require 'mkmf'

$CFLAGS = "-O3 -Wall"

create_makefile('dedup/dedup')

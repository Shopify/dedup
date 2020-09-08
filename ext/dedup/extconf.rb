# frozen_string_literal: true

require 'mkmf'

if RUBY_ENGINE == 'ruby' && have_func("rb_hash_bulk_insert", ["ruby.h"])
  $CFLAGS = "-O3 -Wall"
  create_makefile('dedup/dedup')
else
  File.write("Makefile", dummy_makefile($srcdir).join(""))
end

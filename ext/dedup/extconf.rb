# frozen_string_literal: true

require 'mkmf'

# FIXME: should use have_func("rb_hash_bulk_insert", ["ruby.h"])
if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
  $CFLAGS << " -O3 -Wall "
  create_makefile('dedup/dedup')
else
  File.write("Makefile", dummy_makefile($srcdir).join(""))
end

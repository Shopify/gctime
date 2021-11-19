# frozen_string_literal: true

require "mkmf"

if GC.respond_to?(:total_time)
  File.write("Makefile", dummy_makefile($srcdir).join(""))
else
  $CFLAGS << ' -O3 '
  $CFLAGS << ' -std=c99'

  create_makefile("gctime/gctime")
end

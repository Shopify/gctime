# frozen_string_literal: true
require_relative "gctime/version"

module GCTime
  if GC.respond_to?(:total_time)
    # We're on Ruby 3.1+, nothing to backport.
  elsif GC.stat.key?(:time)
    # We're likely on JRuby or TruffleRuby
    module Backport
      def measure_total_time
        true
      end unless GC.respond_to?(:measure_total_time)

      def measure_total_time=(enabled)
        # noop
      end unless GC.respond_to?(:measure_total_time=)

      def total_time
        (stat(:time) * 1_000_000.0).to_i # nanoseconds integer
      end unless GC.respond_to?(:total_time)
    end

    unless Backport.instance_methods(:false).empty?
      GC.singleton_class.prepend(Backport)
    end
  else
    # We're on MRI 3.0 or older.
    require "gctime/gctime"
    GC.measure_total_time = true

    module Backport
      UNDEF = BasicObject.new

      def stat(key = UNDEF)
        if UNDEF.equal?(key)
          stats = super()
          stats[:time] = ::GCTime._time_ms # milliseconds integer
          stats
        elsif key == :time
          ::GCTime._time_ms # milliseconds integer
        elsif Hash === key
          stats = super
          stats[:time] = ::GCTime._time_ms # milliseconds integer
          stats
        else
          super
        end
      end
    end

    GC.singleton_class.prepend(Backport)
  end
end

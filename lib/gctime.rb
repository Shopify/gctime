# frozen_string_literal: true

require_relative "gctime/version"

module GCTime
  @mutex = Mutex.new
  @total_time = 0.0

  class << self
    def enable
      GC::Profiler.enable
    end

    def disable
      GC::Profiler.disable
    end

    def total_time
      if GC::Profiler.total_time > 0.0
        @mutex.synchronize do
          @total_time += GC::Profiler.total_time
          GC::Profiler.clear
        end
      end
      @total_time
    end
  end
end

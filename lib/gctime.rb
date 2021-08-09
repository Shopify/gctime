# frozen_string_literal: true

require_relative "gctime/version"

module GCTime
  @mutex = Mutex.new
  @total_time = 0.0

  begin
    GC.stat(:time) # Implemented on JRuby and TruffleRuby
    class << self
      def enable
      end

      def disable
      end

      def total_time
        GC.stat(:time).to_f
      end
    end
  rescue ArgumentError
    # MRI Implementation
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
            @total_time += GC::Profiler.total_time * 1_000.0
            GC::Profiler.clear
          end
        end
        @total_time
      end
    end
  end
end

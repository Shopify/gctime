# frozen_string_literal: true

require "test_helper"

class GCTimeTest < Minitest::Test
  def test_total_time_is_increasing
    initial_time = GC.total_time
    100.times { "a" * 100 }
    4.times { GC.start }
    assert_operator initial_time, :<, GC.total_time
  end

  def test_total_time_is_an_integer
    assert_instance_of Integer, GC.total_time
  end

  def test_gc_stat_time_is_a_numeric
    # JRuby and TruffleRuby expose it as a Float number of milliseconds
    # MRI 3.1 as an integer number of milliseconds
    assert_kind_of Numeric, GC.stat(:time)
    assert_kind_of Numeric, GC.stat[:time]
  end

  if RUBY_ENGINE == "truffleruby" && GC.stat({}) == 0
    def test_gc_stat_hash_argument
      skip "TruffleRuby doesn't support GC.stat({})"
    end
  else
    def test_gc_stat_hash_argument
      stats = {}
      GC.stat(stats)
      assert_kind_of Numeric, stats[:time]
    end
  end

  def test_measure_total_time_exists
    assert GC.respond_to?(:measure_total_time)
    assert GC.respond_to?(:measure_total_time=)
  end
end

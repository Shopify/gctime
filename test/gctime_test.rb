# frozen_string_literal: true

require "test_helper"

class GCTimeTest < Minitest::Test
  def setup
    GCTime.enable
  end

  def teardown
    GCTime.disable
  end

  def test_total_time_is_increasing
    initial_time = GCTime.total_time
    100.times { "a" * 100 }
    4.times { GC.start }
    refute_equal initial_time, GCTime.total_time
  end
end

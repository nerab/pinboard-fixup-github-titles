# frozen_string_literal: true

require 'helper'

class TestStats < MiniTest::Test
  attr_reader :stats

  def setup
    @stats = PinboardFixupGithubTitles::Stats.new
  end

  def test_gauge_init
    assert_equal(0, stats.gauge(:posts))
  end

  def test_gauge_set
    stats.gauge(:posts, 42)
    assert_equal(42, stats.gauge(:posts))
  end

  def test_counter_init
    assert_equal(0, stats.counter(:updates))
  end

  def test_increment
    stats.increment(:updates)
    assert_equal(1, stats.counter(:updates))
  end

  def test_to_s
    stats.gauge(:posts, 42)
    stats.gauge(:people, 11)
    stats.increment(:updates)

    3.times do
      stats.increment(:creates)
    end

    assert_equal('creates: 3, people: 11, posts: 42, updates: 1', stats.to_s)
  end
end

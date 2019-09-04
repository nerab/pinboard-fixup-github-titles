# frozen_string_literal: true

require 'helper'

class TestIncludeAll < MiniTest::Test
  def setup
    @base = %w(a b c).extend(PinboardFixupGithubTitles::IncludeAll)
  end

  def test_same
    assert(@base.include_all?(%w|a b c d|))
  end

  def test_additional
    additional = %w(a b c d)
    assert(@base.include_all?(additional))
  end

  def test_missing
    missing = %w(a c)
    refute(@base.include_all?(missing))
  end

  def test_no_overlap
    totally_different = %w(x y z)
    refute(@base.include_all?(totally_different))
  end
end

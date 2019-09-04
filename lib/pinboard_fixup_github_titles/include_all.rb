# frozen_string_literal: true

module PinboardFixupGithubTitles
  module IncludeAll
    def include_all?(other)
      (self - other).empty?
    end
  end
end

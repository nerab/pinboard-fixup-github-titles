# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
end

namespace :docker do
  desc 'Build the image'
  task :build do
    sh 'docker build -t nerab/pinboard-fixup-github-titles:latest .'
  end

  desc 'Publish the image'
  task push: [:build] do
    sh 'docker push nerab/pinboard-fixup-github-titles'
  end
end

task default: :test

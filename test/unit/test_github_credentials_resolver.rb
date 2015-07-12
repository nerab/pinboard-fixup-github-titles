require 'helper'
require 'tempfile'
require 'netrc'
require 'forwardable'

class TestGithubCredentialsResolver < MiniTest::Test
  class TempNetRC
    extend Forwardable
    def_delegators :@netrc_file, :path, :delete

    def initialize(data = {})
      @netrc_file = Tempfile.new(self.class.name)
      add(data)
    end

    def add(data)
      netrc = Netrc.read(netrc_file)

      data.each do |machine, kp|
        netrc[machine] = kp.values
      end

      netrc.save
    end

  private
    attr_reader :netrc_file
  end

  include PinboardFixupGithubTitles
  attr_reader :env, :netrc, :ghcr

  def setup
    @netrc = TempNetRC.new

    @env = {}
    env['NETRC_FILE'] = netrc.path

    @ghcr = GithubCredentialsResolver.new(env)
  end

  def teardown
    netrc.delete
  end

  def test_no_credentials_present
    assert_raises GithubCredentialsResolver::MissingCredentials do
      ghcr.resolve
    end
  end

  def test_netrc
    netrc.add('api.github.com' => {
      login: 'nerab',
      password: '********',
    })

    github_credentials = ghcr.resolve

    assert(github_credentials)
    assert(github_credentials[:netrc])
    assert_equal(netrc.path, github_credentials[:netrc_file])
  ensure
    netrc.delete if netrc
  end
end


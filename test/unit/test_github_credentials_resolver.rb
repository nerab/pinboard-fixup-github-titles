require 'helper'
require 'tempfile'
require 'netrc'

class TestGithubCredentialsResolver < MiniTest::Test
  class TempNetRC
    def initialize(data = {})
      @netrc = Tempfile.new(self.class.name).tap do |temp_file|
        n = Netrc.read(temp_file)

        data.each do |machine, kp|
          n[machine] = kp.values
        end

        n.save
      end
    end

    # TODO Delegate
    def path
      @netrc.path
    end

    # TODO Alias and then delegate?
    def delete
      @netrc.unlink
    end
  end

  include PinboardFixupGithubTitles
  attr_reader :env, :ghcr

  def setup
    @env = {}
    @ghcr = GithubCredentialsResolver.new(env)
  end

  def test_no_credentials_present
    assert_raises GithubCredentialsResolver::MissingCredentials do
      ghcr.resolve
    end
  end

  def test_netrc
    netrc = TempNetRC.new('api.github.com' => {
      login: 'nerab',
      password: '********',
    })
    env['NETRC_FILE'] = netrc.path

    github_credentials = ghcr.resolve

    assert(github_credentials)
    assert(github_credentials[:netrc])
    assert_equal(netrc.path, github_credentials[:netrc_file])
  ensure
    netrc.delete
  end
end


# frozen_string_literal: true

require 'helper'
require 'tempfile'
require 'netrc'
require 'forwardable'

class TestGithubCredentialsResolver < MiniTest::Test
  class TempNetRC
    extend Forwardable
    def_delegators :@netrc_file, :path, :delete

    def initialize(data={})
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
  end

  def test_login_password
    env['GITHUB_LOGIN'] = 'foo'
    env['GITHUB_PASSWORD'] = 'bar'

    github_credentials = ghcr.resolve

    assert(github_credentials)
    assert_equal('foo', github_credentials[:login])
    assert_equal('bar', github_credentials[:password])
  end

  def test_client_id_secret
    env['GITHUB_CLIENT_ID'] = 'foobar'
    env['GITHUB_CLIENT_SECRET'] = '********'

    github_credentials = ghcr.resolve

    assert(github_credentials)
    assert_equal('foobar', github_credentials[:client_id])
    assert_equal('********', github_credentials[:client_secret])
  end

  def test_login_password_precedence
    env['GITHUB_LOGIN'] = 'foo'
    env['GITHUB_PASSWORD'] = 'bar'
    env['GITHUB_CLIENT_ID'] = 'foobar'
    env['GITHUB_CLIENT_SECRET'] = '********'
    netrc.add('api.github.com' => {
      login: 'nerab',
      password: '********',
    })

    github_credentials = ghcr.resolve

    assert(github_credentials)
    assert_equal('foo', github_credentials[:login])
    assert_equal('bar', github_credentials[:password])
  end

  def test_client_id_precedence
    env['GITHUB_CLIENT_ID'] = 'foobar'
    env['GITHUB_CLIENT_SECRET'] = '********'
    netrc.add('api.github.com' => {
      login: 'nerab',
      password: '********',
    })

    github_credentials = ghcr.resolve

    assert(github_credentials)
    assert_equal('foobar', github_credentials[:client_id])
    assert_equal('********', github_credentials[:client_secret])
  end
end

# frozen_string_literal: true

module PinboardFixupGithubTitles
  class GithubCredentialsResolver
    MissingCredentials = Class.new(StandardError) do
      def initialize(netrc_file=Netrc.default_path)
        super("Could not find github credentials in #{netrc_file}")
      end
    end

    def initialize(env=ENV)
      @env = env
    end

    #
    # If set, login + password win over
    #   access token, which (if set) wins over
    #     client_id, client_secret, which (if set) win over
    #       entries in .netrc, which are the preferred way.
    #
    def resolve
      if (login = env['GITHUB_LOGIN']) && (password = env['GITHUB_PASSWORD'])
        { login: login, password: password }
      elsif access_token = env['GITHUB_ACCESS_TOKEN']
        { access_token: access_token }
      elsif (client_id = env['GITHUB_CLIENT_ID']) && (client_secret = env['GITHUB_CLIENT_SECRET'])
        { client_id: client_id, client_secret: client_secret }
      elsif netrc_file = env['NETRC_FILE']
        raise MissingCredentials.new(netrc_file) unless Netrc.read(netrc_file)['api.github.com']
        { netrc: true, netrc_file: netrc_file }
      elsif Netrc.read['api.github.com']
        { netrc: true }
      else
        raise MissingCredentials
      end
    end

    private

    attr_reader :env
  end
end

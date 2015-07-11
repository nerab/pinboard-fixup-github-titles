module PinboardFixupGithubTitles
  class GithubCredentialsResolver
    MissingCredentials = Class.new(StandardError)

    def initialize(env = ENV)
      @env = env
    end

    #
    # If set, login + password win over
    #   access token, which (if set) wins over
    #     client_id, client_secret, which (if set) win over
    #       entries in .netrc, which are the preferred way.
    #
    def resolve
      if login = env['GITHUB_LOGIN'] and password = env['GITHUB_PASSWORD']
        {login: login, password: password}
      elsif access_token = env['GITHUB_ACCESS_TOKEN']
        {access_token: access_token}
      elsif client_id = env['GITHUB_CLIENT_ID'] and client_secret = env['GITHUB_CLIENT_SECRET']
        {client_id: client_id, client_secret: client_secret}
      elsif netrc_file = env['NETRC_FILE'] and Netrc.read(netrc_file)['api.github.com']
        {netrc: true}.tap do |result|
          result[:netrc_file] = netrc_file if netrc_file
        end
      elsif Netrc.read['api.github.com']
        {netrc: true}
      else
        raise MissingCredentials
      end
    end

  private
    attr_reader :env
  end
end

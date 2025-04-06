class GitHubAuthenticator
  require 'jwt'
  require 'octokit'

  def self.generate_jwt
    app_id = ENV['GITHUB_APP_ID']
    private_key_path = Rails.root.join('storage', 'horde-of-greg-management.2025-04-06.private-key.pem')
    private_key = File.read(private_key_path)

    payload = {
      iat: Time.now.to_i,
      exp: Time.now.to_i + (10 * 60), # valid for 10 minutes
      iss: app_id
    }
    JWT.encode(payload, private_key, "RS256")
  end

  def self.new_client
    jwt = generate_jwt
    jwt_client = Octokit::Client.new(bearer_token: jwt)

    org_name = ENV['GITHUB_ORG'] || 'horde-of-greg'
    installations = jwt_client.find_app_installations
    installation = installations.find { |inst| inst.account.login == org_name }
    unless installation
      raise "GitHub installation for organization #{org_name} not found"
    end

    installation_token = jwt_client.create_app_installation_access_token(installation.id).token

    Octokit::Client.new(access_token: installation_token)
  end
end

module Oauth2
  class Oauth2Controller < ApplicationController
    def token
      status, header, res = token_endpoint_authenticator.call(request.env)
      response.headers.merge!(header)
      render :status => status, :text => res.body
    end
    
    def token_endpoint_authenticator
      # set realm as server.example.com
      Rack::OAuth2::Server::Token.new('localhost') do |req, res|
        case req.grant_type
        when :authorization_code
          begin
            @user, @client = Oauth2::AuthorizationCode.authenticate!(req.code)
          rescue Oauth2::AuthorizationCode::InvalidCode
            req.invalid_grant! 'Invalid authorization code.'
          end
        when :refresh_token
          begin
            @user, @client = Oauth2::RefreshToken.authenticate!(req.refresh_token)
          rescue Oauth2::AuthorizationCode::InvalidToken
            req.invalid_grant! 'Invalid authorization code.'
          end
        when :password
          begin
            @user = nil # User.authenticate!(req.username, req.password)
            @client = Oauth2::Client.find(req.client_id)
            req.invalid_client!('Invalid client identifier.') unless @client
            req.invalid_client!('Invalid client secret.')  unless @client.secret_valid?(req.client_secret)
          rescue Exception # User::InvalidCredentials
            req.invalid_grant! 'Invalid resource ownwer credentials.'
          end
        when :assertion
          # I'm not familiar with SAML, so raise error for now.
          req.unsupported_grant_type! "SAML is not supported."
        when :client_credentials
          begin
            @client = Oauth2::Client.find(req.client_id)
            req.invalid_client!('Invalid client identifier.') unless @client
            req.invalid_client!('Invalid client secret.')  unless @client.secret_valid?(req.client_secret)
          rescue Exception 
            req.invalid_grant! 'Invalid client credential.'
          end
        else
          req.unsupported_grant_type! "'#{req.grant_type}' isn't supported."
        end
        access_token = Oauth2::AccessToken.create(:user => @user, :client_id => @client.id)
        res.access_token = access_token.id
        res.expires_in = access_token.expires_in
      end
    end
  end
end
require 'token/client_credentials'
require 'rack/auth/basic'

module Rack
  module OAuth2
    module Server
      class Token < Abstract::Handler
        class Request < Abstract::Request

          def profile(allow_no_profile = false)
            case params['grant_type']
            when 'authorization_code'
              AuthorizationCode
            when 'password'
              Password
            when 'assertion'
              Assertion
            when 'refresh_token'
              RefreshToken
            when 'client_credentials'
              ClientCredentials
            else
              unsupported_grant_type!("'#{params['grant_type']}' isn't supported.")
            end
          end

        end

      end
    end
  end
end
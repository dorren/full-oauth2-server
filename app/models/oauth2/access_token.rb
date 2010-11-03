module Oauth2
  class AccessToken < CouchRest::Model::Base
    use_database OAUTH2_SERVER_DB

    property :client_id
    property :expired_at
    property :refresh_token
    
    def expired?
      false
    end
    
    def revoked?
      false
    end
    
    def expires_in
      3600
    end
  end
end
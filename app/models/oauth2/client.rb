module Oauth2
  class Client < CouchRest::Model::Base
    use_database OAUTH2_SERVER_DB

    property :name
    property :url
    property :app_id
    property :app_secret

    validates_presence_of :name, :url
    
    after_create :set_app_secret
    
    def set_app_secret
      self.app_secret = encrypt(self.id.to_s)
      self.save
    end
    
    def secret_valid?(secret)
      encrypt(self.id) == secret
    end
    
    def encrypt(str)
      Digest::SHA1.hexdigest(str)
    end
  end
end
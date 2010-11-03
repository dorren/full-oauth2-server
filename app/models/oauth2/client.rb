module Oauth2
  class Client < CouchRest::Model::Base
    use_database OAUTH2_SERVER_DB

    property :name
    property :url
    property :app_id
    property :app_secret

    validates_presence_of :name, :url
  end
end
unless defined? COUCHDB_SERVER 
  COUCHDB_SERVER = CouchRest::Server.new "http://admin:password@localhost:5984"
end
OAUTH2_SERVER_DB = COUCHDB_SERVER.database! "oauth2_server_#{Rails.env}"

require 'rack/oauth2'

module FullOauth2Server
  class ApiResource < Rack::OAuth2::Server::Resource
    
    # options
    #   :realm - realm name, used by http basic authentication.
    #   :routes - protected api resource routes
    def initialize(app, options = {}, &authenticator)
      @app = app
      @routes = options[:routes] || []
      super(app, options[:realm], &authenticator)
    end
        
    def call(env)
      request  = Rack::OAuth2::Server::Resource::Request.new(env)
      if protected_route?(request.path_info)
        authenticate!(request)
        env[Rack::OAuth2::ACCESS_TOKEN] = request.access_token
      end
      @app.call(env)
    rescue Rack::OAuth2::Server::Error => e
      e.realm = realm
      e.finish
    end
    
    def protected_route?(path)
      @routes.detect{|x| x =~ path}
    end
    
  end
end

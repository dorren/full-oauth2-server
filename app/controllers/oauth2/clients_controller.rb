module Oauth2
  class ClientsController < ApplicationController
    def index
    end

    def create
      options = params[:oauth2_client]
      @client = Client.new(options)
      if @client.save
        @client.app_secret = Digest::SHA1.hexdigest(@client.id)
        @client.save
        redirect_to(oauth2_client_path(@client.id)) and return
      end
    end
    
    def show
      @client = Client.find(params[:id])
    end
  end
end
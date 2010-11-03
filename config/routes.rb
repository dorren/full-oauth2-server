Rails.application.routes.draw do
  namespace :oauth2 do
    resources :clients
  end
  
  match "oauth/token" => "oauth2/oauth2#token", :as => :token
end
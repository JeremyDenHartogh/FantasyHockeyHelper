Rails.application.routes.draw do
    get 'landing/index'
    get 'auth/:provider/callback', to: 'sessions#custom'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root 'landing#index'
    get 'leagueinfo', to: 'league#info'
    
    
end

Rails.application.routes.draw do
    get 'landing/index'
    get 'auth/:provider/callback', to: 'sessions#custom'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root 'landing#index'
    get 'leagueinfo', to: 'league#info'
    get 'freeagents', to: 'freeagents#full'
    get 'freeagentsC', to: 'freeagents#center'
    get 'freeagentsD', to: 'freeagents#defence'
    get 'freeagentsLW', to: 'freeagents#leftwing'
    get 'freeagentsRW', to: 'freeagents#rightwing'
    get 'freeagentsG', to: 'freeagents#goalie'
    get 'freeagentsF', to: 'freeagents#forward'
    get 'freeagentsS', to: 'freeagents#skater'
    get 'login', to: 'landing#login'
    get 'home', to: 'landing#home'
    get 'standings', to: 'league#standings'
    get 'rankings', to: 'draft#rankings'
    get 'rankingsC', to: 'draft#center'
    get 'rankingsD', to: 'draft#defence'
    get 'rankingsLW', to: 'draft#leftwing'
    get 'rankingsRW', to: 'draft#rightwing'
    get 'rankingsG', to: 'draft#goalie'
    get 'rankingsF', to: 'draft#forward'
    get 'rankingsS', to: 'draft#skater'
    get 'roster', to: 'league#roster'
    match '*path' => redirect('/'), via: :get
end

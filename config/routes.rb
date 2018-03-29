Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'devise/sessions'
  }
  

 
  devise_scope :user do
    authenticated :user do
      root 'events#index', as: :authenticated_root
    end
    get '/redirect', to: 'events#redirect', as: 'redirect'
    get '/callback', to: 'events#callback', as: 'callback'
    get '/calendars', to: 'events#calendars', as: 'calendars'
    post '/events/:calendar_id', to: 'events#new_event', as: 'new_event', calendar_id: /[^\/]+/
    resources :users
    resources :events
    # get "/events/list/all" => 'events#list'
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    resources :comments
  end 
  end
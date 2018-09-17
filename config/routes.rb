Rails.application.routes.draw do
  root 'breweries#index'
  # get( '/', { :to => 'breweries#index' } )
  resources :beers
  resources :breweries
  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  #post 'ratings', to: 'ratings#create'
  resources :ratings, only: [:index, :new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
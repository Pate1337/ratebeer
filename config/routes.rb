Rails.application.routes.draw do
  resources :memberships do
    post 'confirm', on: :member
  end
  resources :beer_clubs
  resources :users
  root 'breweries#index'
  # get( '/', { :to => 'breweries#index' } )
  resources :beers
  resources :breweries
  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  #post 'ratings', to: 'ratings#create'
  resources :ratings, only: [:index, :new, :create, :destroy]
  get 'signup', to: 'users#new'
  resource :session, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  resources :places, only: [:index, :show]
  # mikä generoi samat polut kuin seuraavat kaksi
  # get 'places', to:'places#index'
  # get 'places/:id', to:'places#show'

  post 'places', to:'places#search'
  resources :styles
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :users do
    post 'toggle_closed', on: :member
  end
  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
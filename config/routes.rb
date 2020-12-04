Rails.application.routes.draw do

  resources :operators
  resources :companies do
    member do
      get 'day'
      get 'hour'
    end
  end

  resources :meters do
    member do
      get 'day'
      get 'hour'
    end
  end

  # get 'meter/day'

  root to: 'meters#index'
end

Rails.application.routes.draw do

  resources :operators
  resources :companies do
    member do
      get 'day'
      get 'hour'
      get 'month'
    end
  end

  resources :meters do
    member do
      get 'day'
      get 'hour'
      get 'month'
    end
  end

  # get 'meter/day'

  root to: 'meters#index'
end

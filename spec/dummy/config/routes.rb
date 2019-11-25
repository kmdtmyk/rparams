Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :tests, only: [:index]
  resource :demo, only: [:show]
  match '/examples', to: ExamplesController, via: :get

end
Expensable::Application.routes.draw do
  devise_for :users
  root 'pages#home'

  resource :pages, only: [] do
    member {
      get :about
      get :home
    }
  end
end

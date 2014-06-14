Expensable::Application.routes.draw do
  root 'pages#home'

  resource :pages, only: [] do
    member {
      get :about
      get :home
    }
  end
end

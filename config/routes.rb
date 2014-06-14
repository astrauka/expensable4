Expensable::Application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'omniauth_callbacks',
                            sessions: 'sessions' }

  root 'pages#home'

  resource :pages, only: [] do
    member {
      get :about
      get :home
    }
  end

  namespace :user, module: "users" do
    resources :groups
  end
end

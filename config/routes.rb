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

    namespace :group, module: "groups", path: "groups/:group_id" do
      resources :members, only: [:destroy] do
        member {
          post :deactivate
        }
      end

      resources :invites, only: [:index, :create]

      resources :expenses
    end
  end
end

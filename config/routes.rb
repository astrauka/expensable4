Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
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

  resource :user, only: [:edit, :update]

  namespace :user, module: "users" do
    resources :groups do
      member {
        get :expenses_table
      }
    end

    namespace :group, module: "groups", path: "groups/:group_id" do
      resources :members, only: [] do
        member {
          post :toggle_active
        }
      end

      resources :invites, only: [:index, :create]

      resources :expenses do
        collection {
          get :payback
        }
      end
    end
  end
end

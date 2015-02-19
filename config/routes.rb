Rails.application.routes.draw do
  root "static_pages#home"

  resources :searches, only: :index

  resources :lessons, only: [:index, :show], param: :slug do
    resources :submissions, only: [:index, :create]
    resources :ratings, only: [:create, :update]
  end

  resources :submissions, only: [:show, :update] do
    resources :comments, only: [:create]
  end

  resources :assignments, only: [:show]

  resources :announcements, only: [:show, :destroy]

  resources :announcement_receipts, only: [:create]

  resources :users, only: [:index, :show], param: :username

  resources :teams, only: [:index, :show] do
    resources :assignments, only: [:index, :create]
    resources :announcements, only: [:index, :create]
  end
  resources :question_queues, only: [:create, :update]

  resources :questions do
    resources :answers, only: [:edit, :update, :create, :destroy]
    resources :question_comments, only: [:create, :destroy]
  end

  resources :answers, only: [] do
    resources :answer_comments, only: [:create, :destroy]
  end

  resource :session, only: [:new, :create, :destroy] do
    get "failure", on: :member
  end

  resource :dashboard, only: [:show]

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  get "/start", to: "static_pages#start"
  get "/dailies", to: "static_pages#dailies"
end

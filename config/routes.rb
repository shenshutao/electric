Rails.application.routes.draw do
  get 'onetime_login/index'
  get 'onetime_login/logout'
  get 'usages/newest'
  get 'welcome/index'
  get 'week_history/index'
  get 'month_history/index'
  get 'feedback/index'
  get 'your_goal/index'
  root 'welcome#index'
  resources :articles
  resources :users do
    resources :usages # the electricity usage of each user.
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  get 'welcome/index'
  get 'week_history/index'
  get 'month_history/index'
  get 'feedback/index'
  get 'your_goal/index'
  root 'welcome#index'
  resources :articles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

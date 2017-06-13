Rails.application.routes.draw do
  get 'onetime_login/index'
  get 'onetime_login/goal'
  get 'onetime_login/logout'
  get 'usages/newest'
  get 'usages/newestday'
  get 'usages/dailyConsume'
  get 'usages/weeklyConsume'
  get 'usages/last7days'
  get 'usages/peroid'
  get 'welcome/index'
  get 'welcome/profile'
  get 'welcome/statusinfo'
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

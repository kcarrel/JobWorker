Rails.application.routes.draw do
  resources :jobs
    post '/start', to: 'jobs#start'
    post '/stop', to: 'jobs#stop'
    post '/query', to: 'jobs#query'
    post '/log', to: 'jobs#log'
    get '/here', to: 'jobs#here'

end

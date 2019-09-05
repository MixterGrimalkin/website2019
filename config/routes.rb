Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  get '/project/:id' => 'home#project'

  get '/admin' => 'admin#index'

  get '/new_project' => 'admin#new_project'
  post '/create_project' => 'admin#create_project'

  get '/project/:id/edit' => 'admin#edit_project'
  delete '/project/:id/delete' => 'admin#delete_project'
  post '/update_project/:id' => 'admin#update_project'

  post '/contact_me' => 'home#contact_me'

end

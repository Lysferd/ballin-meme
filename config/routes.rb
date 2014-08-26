
BallinMeme::Application.routes.draw do
  
  root   'home#live'
  get    'live'   => 'home#live'
  get    'admin'  => 'home#admin'
  get    'mobile' => 'mobile#index'
  post   'login'  => 'home#create'
  delete 'logout' => 'home#destroy'
  
  post   'add_camera'   => 'home#add_camera'
  
  get    'send_message' => 'raspis#send_message'
  get    'reconnect'    => 'raspis#reconnect'
  
  get    'test_message' => 'home#test_message'
  get    'get_data'     => 'home#get_data'
  get    'kill_slave'   => 'home#kill_slave'
  
  resources :cameras
  resources :users
  resources :raspis
  
end

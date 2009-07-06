ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate' 
  map.root :controller => "main"

  map.resources :users
  map.resource :session

  map.namespace(:admin) do |a|  
    a.root :controller => "main", :action => :show  
    a.resources :lines
    a.resources :stops
    a.resources :alerts
  end
  
  map.resources :lines
  map.resources :stops, :collection => {:list => :get, :stop_info => :get}
  map.resources :vehicles
  map.resources :alerts
  
  
  
  map.page '/page/:name', :controller => 'pages', :action => 'show', :name => nil
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Routes.draw do |map|
  map.resources :postings

  map.namespace(:admin) do |admin|
    admin.resources :users, :member => { :change_role => :put }
    admin.resources :categories
    admin.resources :posting_types
    admin.root :controller => "main", :action => "index"
  end

  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
#  map.resources :users
  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resource :user_session
  map.change_email 'verify_email/:request_code', :controller => 'change_email', :action => 'edit'
  # Home Page
  map.root :controller => "postings", :action => "index"
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  # Catch all url
  map.connect '*path', :controller => "home", :action => "index"
end

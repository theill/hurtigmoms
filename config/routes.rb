ActionController::Routing::Routes.draw do |map|
  map.resources :fiscal_years, :as => 'regnskaber', :member => { :download_annexes => :get, :overview => :get } do |fy|
    fy.resources :transactions, :as => 'transaktioner', :collection => { :search => :get, :ping => :get, :auto_correct => :post }, :path_names => { :search => 'find' } do |transaction|
      transaction.resources :annexes, :as => 'bilag', :member => { :download => :get, :preview => :get }
      transaction.resources :equalizations
    end
    fy.resources :postings, :as => 'posteringer'
  end
  map.resources :accounts, :as => 'konti'
  map.resources :reports, :as => 'rapporter'
  map.resources :customers, :as => 'kunder', :collection => { :search => :get }, :path_names => { :search => 'find' }
  map.resources :posting_imports, :as => 'kontoudtog-importeringer'
  map.resources :equalizations
  
  map.resources :users do |users|
    users.resource :password, :controller => 'clearance/passwords', :only => [:create, :edit, :update]
    users.resource :confirmation, :controller => 'clearance/confirmations', :only => [:new, :create]
  end
  
  map.resource  :session, :only => [:new, :create, :destroy]
  
  map.namespace :admin do |admin|
    admin.resources :users
  end
  
  map.settings 'indstillinger', :controller => :users, :action => :edit
  map.sign_up 'sign_up', :controller => :users, :action => 'new'
  map.sign_in 'sign_in', :controller => :sessions, :action => 'new'
  map.sign_out 'sign_out', :controller => :sessions, :action => 'destroy', :method => :delete
  map.ping 'ping', :controller => :about, :action => :ping
  map.overview 'oversigt', :controller => :about, :action => :overview
  
  map.api 'api', :controller => 'about', :action => 'api'
  map.tour 'tour', :controller => 'about', :action => 'tour'
  map.help 'hjaelp', :controller => 'about', :action => 'help'
  map.contact 'kontakt', :controller => 'about', :action => 'contact'
  map.privacy 'sikkerhed', :controller => :about, :action => :privacy
  
  map.root :controller => 'about'
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
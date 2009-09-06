ActionController::Routing::Routes.draw do |map|
  map.resources :accounts, :as => 'konti'
  map.resources :postings, :as => 'posteringer', :member => { :download => :get }

  # def map.controller_actions(controller, aktions)
  #   aktions.each do |action|
  #     self.send("#{controller}_#{action}", "#{action}", :controller => controller, :action => action)
  #   end
  # end

  map.resources :users do |users|
    users.resource :password, :controller => 'clearance/passwords', :only => [:create, :edit, :update]
    users.resource :confirmation, :controller => 'clearance/confirmations', :only => [:new, :create]
  end
  
  map.tour 'tour', :controller => 'about', :action => 'tour'
  map.help 'hjaelp', :controller => 'about', :action => 'help'
  map.contact 'kontakt', :controller => 'about', :action => 'contact'

  # map.controller_actions 'about', %w[tour help contact]

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

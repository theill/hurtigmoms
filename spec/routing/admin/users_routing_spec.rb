require 'spec_helper'

describe Admin::UsersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/users" }.should route_to(:controller => "admin_users", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/users/new" }.should route_to(:controller => "admin_users", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/users/1" }.should route_to(:controller => "admin_users", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/users/1/edit" }.should route_to(:controller => "admin_users", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/users" }.should route_to(:controller => "admin_users", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/admin/users/1" }.should route_to(:controller => "admin_users", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/users/1" }.should route_to(:controller => "admin_users", :action => "destroy", :id => "1") 
    end
  end
end

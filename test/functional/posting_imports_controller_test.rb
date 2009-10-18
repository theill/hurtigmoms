require 'test_helper'

class PostingImportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posting_imports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create posting_import" do
    assert_difference('PostingImport.count') do
      post :create, :posting_import => { }
    end

    assert_redirected_to posting_import_path(assigns(:posting_import))
  end

  test "should show posting_import" do
    get :show, :id => posting_imports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => posting_imports(:one).to_param
    assert_response :success
  end

  test "should update posting_import" do
    put :update, :id => posting_imports(:one).to_param, :posting_import => { }
    assert_redirected_to posting_import_path(assigns(:posting_import))
  end

  test "should destroy posting_import" do
    assert_difference('PostingImport.count', -1) do
      delete :destroy, :id => posting_imports(:one).to_param
    end

    assert_redirected_to posting_imports_path
  end
end

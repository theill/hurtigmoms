require 'test_helper'

class PostingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:postings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create posting" do
    assert_difference('Posting.count') do
      post :create, :posting => { }
    end

    assert_redirected_to posting_path(assigns(:posting))
  end

  test "should show posting" do
    get :show, :id => postings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => postings(:one).to_param
    assert_response :success
  end

  test "should update posting" do
    put :update, :id => postings(:one).to_param, :posting => { }
    assert_redirected_to posting_path(assigns(:posting))
  end

  test "should destroy posting" do
    assert_difference('Posting.count', -1) do
      delete :destroy, :id => postings(:one).to_param
    end

    assert_redirected_to postings_path
  end
end

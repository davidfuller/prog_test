require 'test_helper'

class CommonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create common" do
    assert_difference('Common.count') do
      post :create, :common => { }
    end

    assert_redirected_to common_path(assigns(:common))
  end

  test "should show common" do
    get :show, :id => commons(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => commons(:one).to_param
    assert_response :success
  end

  test "should update common" do
    put :update, :id => commons(:one).to_param, :common => { }
    assert_redirected_to common_path(assigns(:common))
  end

  test "should destroy common" do
    assert_difference('Common.count', -1) do
      delete :destroy, :id => commons(:one).to_param
    end

    assert_redirected_to commons_path
  end
end

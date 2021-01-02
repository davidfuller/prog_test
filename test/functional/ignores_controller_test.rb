require 'test_helper'

class IgnoresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ignores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ignore" do
    assert_difference('Ignore.count') do
      post :create, :ignore => { }
    end

    assert_redirected_to ignore_path(assigns(:ignore))
  end

  test "should show ignore" do
    get :show, :id => ignores(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ignores(:one).to_param
    assert_response :success
  end

  test "should update ignore" do
    put :update, :id => ignores(:one).to_param, :ignore => { }
    assert_redirected_to ignore_path(assigns(:ignore))
  end

  test "should destroy ignore" do
    assert_difference('Ignore.count', -1) do
      delete :destroy, :id => ignores(:one).to_param
    end

    assert_redirected_to ignores_path
  end
end

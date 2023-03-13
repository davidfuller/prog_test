require 'test_helper'

class SportsIppsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sports_ipps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sports_ipp" do
    assert_difference('SportsIpp.count') do
      post :create, :sports_ipp => { }
    end

    assert_redirected_to sports_ipp_path(assigns(:sports_ipp))
  end

  test "should show sports_ipp" do
    get :show, :id => sports_ipps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sports_ipps(:one).to_param
    assert_response :success
  end

  test "should update sports_ipp" do
    put :update, :id => sports_ipps(:one).to_param, :sports_ipp => { }
    assert_redirected_to sports_ipp_path(assigns(:sports_ipp))
  end

  test "should destroy sports_ipp" do
    assert_difference('SportsIpp.count', -1) do
      delete :destroy, :id => sports_ipps(:one).to_param
    end

    assert_redirected_to sports_ipps_path
  end
end

require 'test_helper'

class CountdownIppsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:countdown_ipps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create countdown_ipp" do
    assert_difference('CountdownIpp.count') do
      post :create, :countdown_ipp => { }
    end

    assert_redirected_to countdown_ipp_path(assigns(:countdown_ipp))
  end

  test "should show countdown_ipp" do
    get :show, :id => countdown_ipps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => countdown_ipps(:one).to_param
    assert_response :success
  end

  test "should update countdown_ipp" do
    put :update, :id => countdown_ipps(:one).to_param, :countdown_ipp => { }
    assert_redirected_to countdown_ipp_path(assigns(:countdown_ipp))
  end

  test "should destroy countdown_ipp" do
    assert_difference('CountdownIpp.count', -1) do
      delete :destroy, :id => countdown_ipps(:one).to_param
    end

    assert_redirected_to countdown_ipps_path
  end
end

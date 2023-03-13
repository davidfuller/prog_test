require 'test_helper'

class SportsIppStatusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sports_ipp_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sports_ipp_status" do
    assert_difference('SportsIppStatus.count') do
      post :create, :sports_ipp_status => { }
    end

    assert_redirected_to sports_ipp_status_path(assigns(:sports_ipp_status))
  end

  test "should show sports_ipp_status" do
    get :show, :id => sports_ipp_statuses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sports_ipp_statuses(:one).to_param
    assert_response :success
  end

  test "should update sports_ipp_status" do
    put :update, :id => sports_ipp_statuses(:one).to_param, :sports_ipp_status => { }
    assert_redirected_to sports_ipp_status_path(assigns(:sports_ipp_status))
  end

  test "should destroy sports_ipp_status" do
    assert_difference('SportsIppStatus.count', -1) do
      delete :destroy, :id => sports_ipp_statuses(:one).to_param
    end

    assert_redirected_to sports_ipp_statuses_path
  end
end

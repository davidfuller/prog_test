require 'test_helper'

class OnDemandSchedulingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:on_demand_schedulings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create on_demand_scheduling" do
    assert_difference('OnDemandScheduling.count') do
      post :create, :on_demand_scheduling => { }
    end

    assert_redirected_to on_demand_scheduling_path(assigns(:on_demand_scheduling))
  end

  test "should show on_demand_scheduling" do
    get :show, :id => on_demand_schedulings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => on_demand_schedulings(:one).to_param
    assert_response :success
  end

  test "should update on_demand_scheduling" do
    put :update, :id => on_demand_schedulings(:one).to_param, :on_demand_scheduling => { }
    assert_redirected_to on_demand_scheduling_path(assigns(:on_demand_scheduling))
  end

  test "should destroy on_demand_scheduling" do
    assert_difference('OnDemandScheduling.count', -1) do
      delete :destroy, :id => on_demand_schedulings(:one).to_param
    end

    assert_redirected_to on_demand_schedulings_path
  end
end

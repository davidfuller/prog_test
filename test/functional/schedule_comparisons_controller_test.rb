require 'test_helper'

class ScheduleComparisonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedule_comparisons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schedule_comparison" do
    assert_difference('ScheduleComparison.count') do
      post :create, :schedule_comparison => { }
    end

    assert_redirected_to schedule_comparison_path(assigns(:schedule_comparison))
  end

  test "should show schedule_comparison" do
    get :show, :id => schedule_comparisons(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => schedule_comparisons(:one).to_param
    assert_response :success
  end

  test "should update schedule_comparison" do
    put :update, :id => schedule_comparisons(:one).to_param, :schedule_comparison => { }
    assert_redirected_to schedule_comparison_path(assigns(:schedule_comparison))
  end

  test "should destroy schedule_comparison" do
    assert_difference('ScheduleComparison.count', -1) do
      delete :destroy, :id => schedule_comparisons(:one).to_param
    end

    assert_redirected_to schedule_comparisons_path
  end
end

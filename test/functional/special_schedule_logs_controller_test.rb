require 'test_helper'

class SpecialScheduleLogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:special_schedule_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create special_schedule_log" do
    assert_difference('SpecialScheduleLog.count') do
      post :create, :special_schedule_log => { }
    end

    assert_redirected_to special_schedule_log_path(assigns(:special_schedule_log))
  end

  test "should show special_schedule_log" do
    get :show, :id => special_schedule_logs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => special_schedule_logs(:one).to_param
    assert_response :success
  end

  test "should update special_schedule_log" do
    put :update, :id => special_schedule_logs(:one).to_param, :special_schedule_log => { }
    assert_redirected_to special_schedule_log_path(assigns(:special_schedule_log))
  end

  test "should destroy special_schedule_log" do
    assert_difference('SpecialScheduleLog.count', -1) do
      delete :destroy, :id => special_schedule_logs(:one).to_param
    end

    assert_redirected_to special_schedule_logs_path
  end
end

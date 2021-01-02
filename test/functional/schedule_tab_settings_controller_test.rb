require 'test_helper'

class ScheduleTabSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedule_tab_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schedule_tab_setting" do
    assert_difference('ScheduleTabSetting.count') do
      post :create, :schedule_tab_setting => { }
    end

    assert_redirected_to schedule_tab_setting_path(assigns(:schedule_tab_setting))
  end

  test "should show schedule_tab_setting" do
    get :show, :id => schedule_tab_settings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => schedule_tab_settings(:one).to_param
    assert_response :success
  end

  test "should update schedule_tab_setting" do
    put :update, :id => schedule_tab_settings(:one).to_param, :schedule_tab_setting => { }
    assert_redirected_to schedule_tab_setting_path(assigns(:schedule_tab_setting))
  end

  test "should destroy schedule_tab_setting" do
    assert_difference('ScheduleTabSetting.count', -1) do
      delete :destroy, :id => schedule_tab_settings(:one).to_param
    end

    assert_redirected_to schedule_tab_settings_path
  end
end

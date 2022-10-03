require 'test_helper'

class SpecialScheduleSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:special_schedule_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create special_schedule_setting" do
    assert_difference('SpecialScheduleSetting.count') do
      post :create, :special_schedule_setting => { }
    end

    assert_redirected_to special_schedule_setting_path(assigns(:special_schedule_setting))
  end

  test "should show special_schedule_setting" do
    get :show, :id => special_schedule_settings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => special_schedule_settings(:one).to_param
    assert_response :success
  end

  test "should update special_schedule_setting" do
    put :update, :id => special_schedule_settings(:one).to_param, :special_schedule_setting => { }
    assert_redirected_to special_schedule_setting_path(assigns(:special_schedule_setting))
  end

  test "should destroy special_schedule_setting" do
    assert_difference('SpecialScheduleSetting.count', -1) do
      delete :destroy, :id => special_schedule_settings(:one).to_param
    end

    assert_redirected_to special_schedule_settings_path
  end
end

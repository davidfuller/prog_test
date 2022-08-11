require 'test_helper'

class GenerateStatusSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:generate_status_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create generate_status_setting" do
    assert_difference('GenerateStatusSetting.count') do
      post :create, :generate_status_setting => { }
    end

    assert_redirected_to generate_status_setting_path(assigns(:generate_status_setting))
  end

  test "should show generate_status_setting" do
    get :show, :id => generate_status_settings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => generate_status_settings(:one).to_param
    assert_response :success
  end

  test "should update generate_status_setting" do
    put :update, :id => generate_status_settings(:one).to_param, :generate_status_setting => { }
    assert_redirected_to generate_status_setting_path(assigns(:generate_status_setting))
  end

  test "should destroy generate_status_setting" do
    assert_difference('GenerateStatusSetting.count', -1) do
      delete :destroy, :id => generate_status_settings(:one).to_param
    end

    assert_redirected_to generate_status_settings_path
  end
end

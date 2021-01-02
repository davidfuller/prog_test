require 'test_helper'

class PressTabSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:press_tab_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create press_tab_setting" do
    assert_difference('PressTabSetting.count') do
      post :create, :press_tab_setting => { }
    end

    assert_redirected_to press_tab_setting_path(assigns(:press_tab_setting))
  end

  test "should show press_tab_setting" do
    get :show, :id => press_tab_settings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => press_tab_settings(:one).to_param
    assert_response :success
  end

  test "should update press_tab_setting" do
    put :update, :id => press_tab_settings(:one).to_param, :press_tab_setting => { }
    assert_redirected_to press_tab_setting_path(assigns(:press_tab_setting))
  end

  test "should destroy press_tab_setting" do
    assert_difference('PressTabSetting.count', -1) do
      delete :destroy, :id => press_tab_settings(:one).to_param
    end

    assert_redirected_to press_tab_settings_path
  end
end

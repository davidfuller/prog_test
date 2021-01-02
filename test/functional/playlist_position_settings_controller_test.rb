require 'test_helper'

class PlaylistPositionSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:playlist_position_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create playlist_position_setting" do
    assert_difference('PlaylistPositionSetting.count') do
      post :create, :playlist_position_setting => { }
    end

    assert_redirected_to playlist_position_setting_path(assigns(:playlist_position_setting))
  end

  test "should show playlist_position_setting" do
    get :show, :id => playlist_position_settings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => playlist_position_settings(:one).to_param
    assert_response :success
  end

  test "should update playlist_position_setting" do
    put :update, :id => playlist_position_settings(:one).to_param, :playlist_position_setting => { }
    assert_redirected_to playlist_position_setting_path(assigns(:playlist_position_setting))
  end

  test "should destroy playlist_position_setting" do
    assert_difference('PlaylistPositionSetting.count', -1) do
      delete :destroy, :id => playlist_position_settings(:one).to_param
    end

    assert_redirected_to playlist_position_settings_path
  end
end

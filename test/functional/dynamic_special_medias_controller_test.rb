require 'test_helper'

class DynamicSpecialMediasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_special_medias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_special_media" do
    assert_difference('DynamicSpecialMedia.count') do
      post :create, :dynamic_special_media => { }
    end

    assert_redirected_to dynamic_special_media_path(assigns(:dynamic_special_media))
  end

  test "should show dynamic_special_media" do
    get :show, :id => dynamic_special_medias(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_special_medias(:one).to_param
    assert_response :success
  end

  test "should update dynamic_special_media" do
    put :update, :id => dynamic_special_medias(:one).to_param, :dynamic_special_media => { }
    assert_redirected_to dynamic_special_media_path(assigns(:dynamic_special_media))
  end

  test "should destroy dynamic_special_media" do
    assert_difference('DynamicSpecialMedia.count', -1) do
      delete :destroy, :id => dynamic_special_medias(:one).to_param
    end

    assert_redirected_to dynamic_special_medias_path
  end
end

require 'test_helper'

class SportsIppMediasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sports_ipp_medias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sports_ipp_media" do
    assert_difference('SportsIppMedia.count') do
      post :create, :sports_ipp_media => { }
    end

    assert_redirected_to sports_ipp_media_path(assigns(:sports_ipp_media))
  end

  test "should show sports_ipp_media" do
    get :show, :id => sports_ipp_medias(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sports_ipp_medias(:one).to_param
    assert_response :success
  end

  test "should update sports_ipp_media" do
    put :update, :id => sports_ipp_medias(:one).to_param, :sports_ipp_media => { }
    assert_redirected_to sports_ipp_media_path(assigns(:sports_ipp_media))
  end

  test "should destroy sports_ipp_media" do
    assert_difference('SportsIppMedia.count', -1) do
      delete :destroy, :id => sports_ipp_medias(:one).to_param
    end

    assert_redirected_to sports_ipp_medias_path
  end
end

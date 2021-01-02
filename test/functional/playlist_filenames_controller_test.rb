require 'test_helper'

class PlaylistFilenamesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:playlist_filenames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create playlist_filename" do
    assert_difference('PlaylistFilename.count') do
      post :create, :playlist_filename => { }
    end

    assert_redirected_to playlist_filename_path(assigns(:playlist_filename))
  end

  test "should show playlist_filename" do
    get :show, :id => playlist_filenames(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => playlist_filenames(:one).to_param
    assert_response :success
  end

  test "should update playlist_filename" do
    put :update, :id => playlist_filenames(:one).to_param, :playlist_filename => { }
    assert_redirected_to playlist_filename_path(assigns(:playlist_filename))
  end

  test "should destroy playlist_filename" do
    assert_difference('PlaylistFilename.count', -1) do
      delete :destroy, :id => playlist_filenames(:one).to_param
    end

    assert_redirected_to playlist_filenames_path
  end
end

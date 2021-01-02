require 'test_helper'

class PlaylistLinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:playlist_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create playlist_line" do
    assert_difference('PlaylistLine.count') do
      post :create, :playlist_line => { }
    end

    assert_redirected_to playlist_line_path(assigns(:playlist_line))
  end

  test "should show playlist_line" do
    get :show, :id => playlist_lines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => playlist_lines(:one).to_param
    assert_response :success
  end

  test "should update playlist_line" do
    put :update, :id => playlist_lines(:one).to_param, :playlist_line => { }
    assert_redirected_to playlist_line_path(assigns(:playlist_line))
  end

  test "should destroy playlist_line" do
    assert_difference('PlaylistLine.count', -1) do
      delete :destroy, :id => playlist_lines(:one).to_param
    end

    assert_redirected_to playlist_lines_path
  end
end

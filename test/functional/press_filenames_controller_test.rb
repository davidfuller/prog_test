require 'test_helper'

class PressFilenamesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:press_filenames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create press_filename" do
    assert_difference('PressFilename.count') do
      post :create, :press_filename => { }
    end

    assert_redirected_to press_filename_path(assigns(:press_filename))
  end

  test "should show press_filename" do
    get :show, :id => press_filenames(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => press_filenames(:one).to_param
    assert_response :success
  end

  test "should update press_filename" do
    put :update, :id => press_filenames(:one).to_param, :press_filename => { }
    assert_redirected_to press_filename_path(assigns(:press_filename))
  end

  test "should destroy press_filename" do
    assert_difference('PressFilename.count', -1) do
      delete :destroy, :id => press_filenames(:one).to_param
    end

    assert_redirected_to press_filenames_path
  end
end

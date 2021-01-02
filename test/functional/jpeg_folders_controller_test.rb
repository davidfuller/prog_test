require 'test_helper'

class JpegFoldersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jpeg_folders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create jpeg_folder" do
    assert_difference('JpegFolder.count') do
      post :create, :jpeg_folder => { }
    end

    assert_redirected_to jpeg_folder_path(assigns(:jpeg_folder))
  end

  test "should show jpeg_folder" do
    get :show, :id => jpeg_folders(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => jpeg_folders(:one).to_param
    assert_response :success
  end

  test "should update jpeg_folder" do
    put :update, :id => jpeg_folders(:one).to_param, :jpeg_folder => { }
    assert_redirected_to jpeg_folder_path(assigns(:jpeg_folder))
  end

  test "should destroy jpeg_folder" do
    assert_difference('JpegFolder.count', -1) do
      delete :destroy, :id => jpeg_folders(:one).to_param
    end

    assert_redirected_to jpeg_folders_path
  end
end

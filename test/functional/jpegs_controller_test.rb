require 'test_helper'

class JpegsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jpegs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create jpeg" do
    assert_difference('Jpeg.count') do
      post :create, :jpeg => { }
    end

    assert_redirected_to jpeg_path(assigns(:jpeg))
  end

  test "should show jpeg" do
    get :show, :id => jpegs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => jpegs(:one).to_param
    assert_response :success
  end

  test "should update jpeg" do
    put :update, :id => jpegs(:one).to_param, :jpeg => { }
    assert_redirected_to jpeg_path(assigns(:jpeg))
  end

  test "should destroy jpeg" do
    assert_difference('Jpeg.count', -1) do
      delete :destroy, :id => jpegs(:one).to_param
    end

    assert_redirected_to jpegs_path
  end
end

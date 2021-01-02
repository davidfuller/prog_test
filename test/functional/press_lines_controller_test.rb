require 'test_helper'

class PressLinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:press_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create press_line" do
    assert_difference('PressLine.count') do
      post :create, :press_line => { }
    end

    assert_redirected_to press_line_path(assigns(:press_line))
  end

  test "should show press_line" do
    get :show, :id => press_lines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => press_lines(:one).to_param
    assert_response :success
  end

  test "should update press_line" do
    put :update, :id => press_lines(:one).to_param, :press_line => { }
    assert_redirected_to press_line_path(assigns(:press_line))
  end

  test "should destroy press_line" do
    assert_difference('PressLine.count', -1) do
      delete :destroy, :id => press_lines(:one).to_param
    end

    assert_redirected_to press_lines_path
  end
end

require 'test_helper'

class ScheduleLinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedule_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schedule_line" do
    assert_difference('ScheduleLine.count') do
      post :create, :schedule_line => { }
    end

    assert_redirected_to schedule_line_path(assigns(:schedule_line))
  end

  test "should show schedule_line" do
    get :show, :id => schedule_lines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => schedule_lines(:one).to_param
    assert_response :success
  end

  test "should update schedule_line" do
    put :update, :id => schedule_lines(:one).to_param, :schedule_line => { }
    assert_redirected_to schedule_line_path(assigns(:schedule_line))
  end

  test "should destroy schedule_line" do
    assert_difference('ScheduleLine.count', -1) do
      delete :destroy, :id => schedule_lines(:one).to_param
    end

    assert_redirected_to schedule_lines_path
  end
end

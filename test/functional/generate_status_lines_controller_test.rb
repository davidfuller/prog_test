require 'test_helper'

class GenerateStatusLinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:generate_status_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create generate_status_line" do
    assert_difference('GenerateStatusLine.count') do
      post :create, :generate_status_line => { }
    end

    assert_redirected_to generate_status_line_path(assigns(:generate_status_line))
  end

  test "should show generate_status_line" do
    get :show, :id => generate_status_lines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => generate_status_lines(:one).to_param
    assert_response :success
  end

  test "should update generate_status_line" do
    put :update, :id => generate_status_lines(:one).to_param, :generate_status_line => { }
    assert_redirected_to generate_status_line_path(assigns(:generate_status_line))
  end

  test "should destroy generate_status_line" do
    assert_difference('GenerateStatusLine.count', -1) do
      delete :destroy, :id => generate_status_lines(:one).to_param
    end

    assert_redirected_to generate_status_lines_path
  end
end

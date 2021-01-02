require 'test_helper'

class ScheduleFilesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedule_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schedule_file" do
    assert_difference('ScheduleFile.count') do
      post :create, :schedule_file => { }
    end

    assert_redirected_to schedule_file_path(assigns(:schedule_file))
  end

  test "should show schedule_file" do
    get :show, :id => schedule_files(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => schedule_files(:one).to_param
    assert_response :success
  end

  test "should update schedule_file" do
    put :update, :id => schedule_files(:one).to_param, :schedule_file => { }
    assert_redirected_to schedule_file_path(assigns(:schedule_file))
  end

  test "should destroy schedule_file" do
    assert_difference('ScheduleFile.count', -1) do
      delete :destroy, :id => schedule_files(:one).to_param
    end

    assert_redirected_to schedule_files_path
  end
end

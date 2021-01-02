require 'test_helper'

class SeriesNumbersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:series_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create series_number" do
    assert_difference('SeriesNumber.count') do
      post :create, :series_number => { }
    end

    assert_redirected_to series_number_path(assigns(:series_number))
  end

  test "should show series_number" do
    get :show, :id => series_numbers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => series_numbers(:one).to_param
    assert_response :success
  end

  test "should update series_number" do
    put :update, :id => series_numbers(:one).to_param, :series_number => { }
    assert_redirected_to series_number_path(assigns(:series_number))
  end

  test "should destroy series_number" do
    assert_difference('SeriesNumber.count', -1) do
      delete :destroy, :id => series_numbers(:one).to_param
    end

    assert_redirected_to series_numbers_path
  end
end

require 'test_helper'

class DynamicSpecialFieldsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_special_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_special_field" do
    assert_difference('DynamicSpecialField.count') do
      post :create, :dynamic_special_field => { }
    end

    assert_redirected_to dynamic_special_field_path(assigns(:dynamic_special_field))
  end

  test "should show dynamic_special_field" do
    get :show, :id => dynamic_special_fields(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_special_fields(:one).to_param
    assert_response :success
  end

  test "should update dynamic_special_field" do
    put :update, :id => dynamic_special_fields(:one).to_param, :dynamic_special_field => { }
    assert_redirected_to dynamic_special_field_path(assigns(:dynamic_special_field))
  end

  test "should destroy dynamic_special_field" do
    assert_difference('DynamicSpecialField.count', -1) do
      delete :destroy, :id => dynamic_special_fields(:one).to_param
    end

    assert_redirected_to dynamic_special_fields_path
  end
end

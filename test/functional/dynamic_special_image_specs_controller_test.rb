require 'test_helper'

class DynamicSpecialImageSpecsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_special_image_specs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_special_image_spec" do
    assert_difference('DynamicSpecialImageSpec.count') do
      post :create, :dynamic_special_image_spec => { }
    end

    assert_redirected_to dynamic_special_image_spec_path(assigns(:dynamic_special_image_spec))
  end

  test "should show dynamic_special_image_spec" do
    get :show, :id => dynamic_special_image_specs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_special_image_specs(:one).to_param
    assert_response :success
  end

  test "should update dynamic_special_image_spec" do
    put :update, :id => dynamic_special_image_specs(:one).to_param, :dynamic_special_image_spec => { }
    assert_redirected_to dynamic_special_image_spec_path(assigns(:dynamic_special_image_spec))
  end

  test "should destroy dynamic_special_image_spec" do
    assert_difference('DynamicSpecialImageSpec.count', -1) do
      delete :destroy, :id => dynamic_special_image_specs(:one).to_param
    end

    assert_redirected_to dynamic_special_image_specs_path
  end
end

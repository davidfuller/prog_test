require 'test_helper'

class DynamicSpecialLogosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_special_logos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_special_logo" do
    assert_difference('DynamicSpecialLogo.count') do
      post :create, :dynamic_special_logo => { }
    end

    assert_redirected_to dynamic_special_logo_path(assigns(:dynamic_special_logo))
  end

  test "should show dynamic_special_logo" do
    get :show, :id => dynamic_special_logos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_special_logos(:one).to_param
    assert_response :success
  end

  test "should update dynamic_special_logo" do
    put :update, :id => dynamic_special_logos(:one).to_param, :dynamic_special_logo => { }
    assert_redirected_to dynamic_special_logo_path(assigns(:dynamic_special_logo))
  end

  test "should destroy dynamic_special_logo" do
    assert_difference('DynamicSpecialLogo.count', -1) do
      delete :destroy, :id => dynamic_special_logos(:one).to_param
    end

    assert_redirected_to dynamic_special_logos_path
  end
end

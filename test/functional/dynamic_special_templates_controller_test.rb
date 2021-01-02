require 'test_helper'

class DynamicSpecialTemplatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_special_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_special_template" do
    assert_difference('DynamicSpecialTemplate.count') do
      post :create, :dynamic_special_template => { }
    end

    assert_redirected_to dynamic_special_template_path(assigns(:dynamic_special_template))
  end

  test "should show dynamic_special_template" do
    get :show, :id => dynamic_special_templates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_special_templates(:one).to_param
    assert_response :success
  end

  test "should update dynamic_special_template" do
    put :update, :id => dynamic_special_templates(:one).to_param, :dynamic_special_template => { }
    assert_redirected_to dynamic_special_template_path(assigns(:dynamic_special_template))
  end

  test "should destroy dynamic_special_template" do
    assert_difference('DynamicSpecialTemplate.count', -1) do
      delete :destroy, :id => dynamic_special_templates(:one).to_param
    end

    assert_redirected_to dynamic_special_templates_path
  end
end

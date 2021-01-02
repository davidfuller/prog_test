require 'test_helper'

class TemplateFieldJoinsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:template_field_joins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template_field_join" do
    assert_difference('TemplateFieldJoin.count') do
      post :create, :template_field_join => { }
    end

    assert_redirected_to template_field_join_path(assigns(:template_field_join))
  end

  test "should show template_field_join" do
    get :show, :id => template_field_joins(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => template_field_joins(:one).to_param
    assert_response :success
  end

  test "should update template_field_join" do
    put :update, :id => template_field_joins(:one).to_param, :template_field_join => { }
    assert_redirected_to template_field_join_path(assigns(:template_field_join))
  end

  test "should destroy template_field_join" do
    assert_difference('TemplateFieldJoin.count', -1) do
      delete :destroy, :id => template_field_joins(:one).to_param
    end

    assert_redirected_to template_field_joins_path
  end
end

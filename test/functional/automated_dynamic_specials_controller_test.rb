require 'test_helper'

class AutomatedDynamicSpecialsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:automated_dynamic_specials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create automated_dynamic_special" do
    assert_difference('AutomatedDynamicSpecial.count') do
      post :create, :automated_dynamic_special => { }
    end

    assert_redirected_to automated_dynamic_special_path(assigns(:automated_dynamic_special))
  end

  test "should show automated_dynamic_special" do
    get :show, :id => automated_dynamic_specials(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => automated_dynamic_specials(:one).to_param
    assert_response :success
  end

  test "should update automated_dynamic_special" do
    put :update, :id => automated_dynamic_specials(:one).to_param, :automated_dynamic_special => { }
    assert_redirected_to automated_dynamic_special_path(assigns(:automated_dynamic_special))
  end

  test "should destroy automated_dynamic_special" do
    assert_difference('AutomatedDynamicSpecial.count', -1) do
      delete :destroy, :id => automated_dynamic_specials(:one).to_param
    end

    assert_redirected_to automated_dynamic_specials_path
  end
end

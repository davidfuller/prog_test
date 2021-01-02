require 'test_helper'

class ComparisonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comparisons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comparison" do
    assert_difference('Comparison.count') do
      post :create, :comparison => { }
    end

    assert_redirected_to comparison_path(assigns(:comparison))
  end

  test "should show comparison" do
    get :show, :id => comparisons(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => comparisons(:one).to_param
    assert_response :success
  end

  test "should update comparison" do
    put :update, :id => comparisons(:one).to_param, :comparison => { }
    assert_redirected_to comparison_path(assigns(:comparison))
  end

  test "should destroy comparison" do
    assert_difference('Comparison.count', -1) do
      delete :destroy, :id => comparisons(:one).to_param
    end

    assert_redirected_to comparisons_path
  end
end

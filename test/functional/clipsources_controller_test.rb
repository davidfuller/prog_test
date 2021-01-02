require 'test_helper'

class ClipsourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clipsources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clipsource" do
    assert_difference('Clipsource.count') do
      post :create, :clipsource => { }
    end

    assert_redirected_to clipsource_path(assigns(:clipsource))
  end

  test "should show clipsource" do
    get :show, :id => clipsources(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => clipsources(:one).to_param
    assert_response :success
  end

  test "should update clipsource" do
    put :update, :id => clipsources(:one).to_param, :clipsource => { }
    assert_redirected_to clipsource_path(assigns(:clipsource))
  end

  test "should destroy clipsource" do
    assert_difference('Clipsource.count', -1) do
      delete :destroy, :id => clipsources(:one).to_param
    end

    assert_redirected_to clipsources_path
  end
end

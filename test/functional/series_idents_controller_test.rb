require 'test_helper'

class SeriesIdentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:series_idents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create series_ident" do
    assert_difference('SeriesIdent.count') do
      post :create, :series_ident => { }
    end

    assert_redirected_to series_ident_path(assigns(:series_ident))
  end

  test "should show series_ident" do
    get :show, :id => series_idents(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => series_idents(:one).to_param
    assert_response :success
  end

  test "should update series_ident" do
    put :update, :id => series_idents(:one).to_param, :series_ident => { }
    assert_redirected_to series_ident_path(assigns(:series_ident))
  end

  test "should destroy series_ident" do
    assert_difference('SeriesIdent.count', -1) do
      delete :destroy, :id => series_idents(:one).to_param
    end

    assert_redirected_to series_idents_path
  end
end

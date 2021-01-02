require 'test_helper'

class CrossChannelPrioritiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cross_channel_priorities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cross_channel_priority" do
    assert_difference('CrossChannelPriority.count') do
      post :create, :cross_channel_priority => { }
    end

    assert_redirected_to cross_channel_priority_path(assigns(:cross_channel_priority))
  end

  test "should show cross_channel_priority" do
    get :show, :id => cross_channel_priorities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cross_channel_priorities(:one).to_param
    assert_response :success
  end

  test "should update cross_channel_priority" do
    put :update, :id => cross_channel_priorities(:one).to_param, :cross_channel_priority => { }
    assert_redirected_to cross_channel_priority_path(assigns(:cross_channel_priority))
  end

  test "should destroy cross_channel_priority" do
    assert_difference('CrossChannelPriority.count', -1) do
      delete :destroy, :id => cross_channel_priorities(:one).to_param
    end

    assert_redirected_to cross_channel_priorities_path
  end
end

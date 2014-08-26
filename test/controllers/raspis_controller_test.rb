require 'test_helper'

class RaspisControllerTest < ActionController::TestCase
  setup do
    @raspi = raspis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:raspis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create raspi" do
    assert_difference('Raspi.count') do
      post :create, raspi: { ipv4: @raspi.ipv4, label: @raspi.label, user_id: @raspi.user_id }
    end

    assert_redirected_to raspi_path(assigns(:raspi))
  end

  test "should show raspi" do
    get :show, id: @raspi
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @raspi
    assert_response :success
  end

  test "should update raspi" do
    patch :update, id: @raspi, raspi: { ipv4: @raspi.ipv4, label: @raspi.label, user_id: @raspi.user_id }
    assert_redirected_to raspi_path(assigns(:raspi))
  end

  test "should destroy raspi" do
    assert_difference('Raspi.count', -1) do
      delete :destroy, id: @raspi
    end

    assert_redirected_to raspis_path
  end
end

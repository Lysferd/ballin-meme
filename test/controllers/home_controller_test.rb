require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get live" do
    get :live
    assert_response :success
  end

  test "should get rtsp" do
    get :rtsp
    assert_response :success
  end

  test "should get hls" do
    get :hls
    assert_response :success
  end

end

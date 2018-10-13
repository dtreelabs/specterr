require 'test_helper'

class TestControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get test_list_url
    assert_response :success
  end

end

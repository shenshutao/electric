require 'test_helper'

class OnetimeLoginControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get onetime_login_index_url
    assert_response :success
  end

end

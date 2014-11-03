require 'test_helper'

class LaptopsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
# TODO add test get index with 'q' in params
# TODO add test get index using post form
# TODO add test get index without any params
end

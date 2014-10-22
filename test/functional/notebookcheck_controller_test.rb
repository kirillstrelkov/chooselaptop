require 'test_helper'

class NotebookcheckControllerTest < ActionController::TestCase
  test "should get cpus" do
    get :cpus
    assert_response :success
  end

  test "should get gpus" do
    get :gpus
    assert_response :success
  end

end

# frozen_string_literal: true

require 'test_helper'

class NotebookcheckControllerTest < ActionController::TestCase
  test 'should get cpus' do
    get :cpus
    assert_response :success
  end

  test 'should get gpus' do
    get :gpus
    assert_response :success
  end

  test 'should get non empty list of cpus' do
    get :cpus, format: :json
    data = JSON.parse(@response.body, symbolize_names: true)
    assert(!data.empty?, 'Return value should NOT be empty')
    assert_not_equal('unknown', data[0][:name])
    assert_not_equal(-1, data[0][:index])
    assert_not_nil(data[0][:href])
  end

  test 'should get non empty list of gpus' do
    get :gpus, format: :json
    data = JSON.parse(@response.body, symbolize_names: true)
    assert(!data.empty?, 'Return value should NOT be empty')
    assert_not_equal('unknown', data[0][:name])
    assert_not_equal(-1, data[0][:index])
    assert_not_nil(data[0][:href])
  end
end

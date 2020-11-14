# frozen_string_literal: true

require 'test_helper'

class QueryControllerTest < ActionController::TestCase
  test 'should get first query data from db' do
    get :get, params: { hash: '27213eaeb427ddcd3d9d77e7770bb40f', format: :json }
    data = JSON.parse(@response.body, symbolize_names: true)
    assert_equal(data[:delimiter], 'EUR')
    assert_equal(data[:query_string], 'qwienqowenqwoEURpdmfpdsmfpdsfEUR')
    assert_equal(data[:hash_string], '27213eaeb427ddcd3d9d77e7770bb40f')
  end

  test 'should get second query data from db' do
    get :get, params: { hash: '8b806d820756dbff2db035554d28e83c', format: :json }
    data = JSON.parse(@response.body, symbolize_names: true)
    assert_equal(data[:delimiter], 'LL')
    assert_equal(data[:query_string], 'oweqrnowernoLLperwenfdsLL sdf dsfllLL324')
    assert_equal(data[:hash_string], '8b806d820756dbff2db035554d28e83c')
  end

  test 'should get posted query' do
    query = 'xcvxcYvcxvY'
    delimiter = 'Y'
    hash = 'd8e356dd6c99c880604515b81cc916f6'
    post :create, params: { query: query, delimiter: delimiter, format: :json }
    data = JSON.parse(@response.body, symbolize_names: true)
    assert_equal(data[:hash_string], hash)
    assert_equal(data.keys.length, 1)
  end

  test 'should get null query for numeric query and delimiter' do
    query = 546_546_546
    delimiter = 4
    post :create, params: { query: query, delimiter: delimiter, format: :json }
    assert_equal(@response.body, 'null')
  end
end

require 'test_helper'

class QueryHelperTest < ActionView::TestCase
  include QueryHelper
  def test_get_query_by_hash
    query = get_query('27213eaeb427ddcd3d9d77e7770bb40f')
    assert_equal(query[:delimiter], 'EUR')
    assert_equal(query[:query_string], 'qwienqowenqwoEURpdmfpdsmfpdsfEUR')
    assert_equal(query[:hash_string], '27213eaeb427ddcd3d9d77e7770bb40f')
  end

  def test_get_query_by_hash2
    query = get_query('8b806d820756dbff2db035554d28e83c')
    assert_equal(query[:delimiter], 'LL')
    assert_equal(query[:query_string], 'oweqrnowernoLLperwenfdsLL sdf dsfllLL324')
    assert_equal(query[:hash_string], '8b806d820756dbff2db035554d28e83c')
  end

  def test_get_query_by_incorrect_hash
    query = get_query('df')
    assert_nil query
  end

  def test_get_query_by_incorrect_numeric_hash
    query = get_query(6)
    assert_nil query
  end

  def test_post_query_with_correct_data
    query_string = 'intel 3333$ intel 3333$'
    delimiter = '$'
    expected_hash = 'ac17188130171154f3ca2bcf2902211a'

    query = post_query(query_string, delimiter)
    assert_equal(query[:delimiter], delimiter)
    assert_equal(query[:query_string], query_string)
    assert_equal(query[:hash_string], expected_hash)
    
    # checking that new query is in DB
    query = get_query(expected_hash)
    assert_equal(query[:delimiter], delimiter)
    assert_equal(query[:query_string], query_string)
    assert_equal(query[:hash_string], expected_hash)
  end

  def test_post_double_data
    query_string = 'oweqrnowernoLLperwenfdsLL sdf dsfllLL324'
    delimiter = 'LL'
    expected_hash = '8b806d820756dbff2db035554d28e83c'

    query = post_query(query_string, delimiter)
    assert_equal(query[:delimiter], delimiter)
    assert_equal(query[:query_string], query_string)
    assert_equal(query[:hash_string], expected_hash)
  end

  def test_post_query_with_incorrect_data
    query = post_query(nil, nil)
    assert_nil query
  end

  def test_post_query_with_incorrect_data
    query = post_query(546546546, 4)
    assert_nil query
  end
end

# frozen_string_literal: true

require 'digest/md5'

class AddSingleRecord < ActiveRecord::Migration[5.2]
  def up
    query = %{Dell Inspiron 15 (3542) Синий 272383519
15.6" HD (1366X768) LED Glare, Intel Core i5-4210U (up to 2.7Ghz/3MB), NVIDIA GeForce 820M 2GB DDR3L, 4GB (1x4GB) DDR3L-1600MHz, SATA 500GB 5400rpm, T...
519.00 EUR


Dell Inspiron 15 (3542) Черный 272383526
15.6" HD (1366X768) LED Glare, Intel Core i5-4210U (up to 2.7Ghz/3MB), NVIDIA GeForce 820M 2GB DDR3L, 4GB (1x4GB) DDR3L-1600MHz, SATA 500GB 5400rpm, T...
519.00 EUR


Dell Inspiron 15 (3542) Серебристый 272383527
15.6" HD (1366X768) LED Glare, Intel Core i5-4210U (up to 2.7Ghz/3MB), NVIDIA GeForce 820M 2GB DDR3L, 4GB (1x4GB) DDR3L-1600MHz, SATA 500GB 5400rpm, T...
519.00 EUR}
    delimiter = 'EUR'
    md5 = Digest::MD5.new
    md5.update(query)
    md5.update(delimiter)
    hash = md5.hexdigest
    Query.create!(hash_string: hash, delimiter: delimiter, query_string: query)
  end

  def down
    Query.delete_all
  end
end

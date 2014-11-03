class AddIndexToHashString < ActiveRecord::Migration
  def change
    add_index :queries, :hash_string, :unique => true
  end
end

# frozen_string_literal: true

class AddIndexToHashString < ActiveRecord::Migration[5.2]
  def change
    add_index :queries, :hash_string, unique: true
  end
end

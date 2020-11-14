# frozen_string_literal: true

class CreateQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :queries do |t|
      t.string :hash_string
      t.string :delimiter
      t.text :query_string

      t.timestamps
    end
  end
end

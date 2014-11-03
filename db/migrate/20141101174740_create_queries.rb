class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :hash_string
      t.string :delimiter
      t.text :query_string

      t.timestamps
    end
  end
end

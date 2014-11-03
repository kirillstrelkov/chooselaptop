class Query < ActiveRecord::Base
  self.include_root_in_json = false
  attr_accessible :delimiter, :hash_string, :query_string
end

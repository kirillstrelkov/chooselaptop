# frozen_string_literal: true

class Query < ActiveRecord::Base
  self.include_root_in_json = false
end

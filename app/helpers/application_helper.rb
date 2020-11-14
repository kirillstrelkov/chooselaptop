# frozen_string_literal: true

module ApplicationHelper
  def format_percentage(number)
    return 'No data' if number == LaptopsHelper::TOP_VALUE

    number = (number * 100).to_f.round(2)
    "#{format('%05.2f', number)}%"
  end
end

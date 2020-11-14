# frozen_string_literal: true

class LaptopsController < ApplicationController
  include QueryHelper
  include LaptopsHelper
  include NotebookcheckHelper
  def index
    @description = DEFAULT_DESC
    @title = DEFAULT_TITLE
    result = nil
    hash = params[:q]
    result = get_query(hash) unless hash.nil?
    if !hash.nil? && !result.nil?
      @laptops = result[:query_string]
      delimiter = result[:delimiter]
    else
      @laptops = params[:laptops]
      delimiter = params[:delimiter]
    end

    @delimiter = if delimiter.nil? || delimiter.strip.empty?
                   nil
                 else
                   delimiter.strip
                 end

    @use_delimiter = if params[:use_delimiter] == 'yes' && !@delimiter.nil?
                       true
                     elsif params[:use_delimiter].nil? && !hash.nil? && !@delimiter.nil?
                       true
                     else
                       false
                     end

    @cpu_href = @@cpu_url
    @gpu_href = @@gpu_url

    if @laptops.nil?
      @sorted_laptops = []
    else
      @sorted_laptops = if @use_delimiter
                          get_sorted_laptops_from_text(@laptops, @delimiter)
                        else
                          get_sorted_laptops_from_text(@laptops)
                        end
      if @sorted_laptops
        @good_laptops_count = get_good_laptops_count(@sorted_laptops)
        @bad_laptops_count = get_bad_laptops_count(@sorted_laptops)
        @title = "#{@sorted_laptops.length} laptops sorted by CPU, GPU and price"
        @description = "Which laptop has the best CPU, GPU and price between #{@sorted_laptops.length} laptops"
      end
    end
  end
end

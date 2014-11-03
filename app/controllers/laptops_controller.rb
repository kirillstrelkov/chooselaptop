class LaptopsController < ApplicationController
  include QueryHelper
  include LaptopsHelper
  include NotebookcheckHelper
  def index
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
    
    if delimiter.nil? or delimiter.strip.length == 0
      @delimiter = nil
    else
      @delimiter = delimiter.strip
    end

    if params[:use_delimiter] == 'yes' && !@delimiter.nil?
      @use_delimiter = true
    elsif params[:use_delimiter].nil? && !hash.nil? && !@delimiter.nil?
      @use_delimiter = true
    else
      @use_delimiter = false
    end

    @cpu_href = @@cpu_url
    @gpu_href = @@gpu_url

    unless @laptops.nil?
      if @use_delimiter
        @sorted_laptops = get_sorted_laptops_from_text(@laptops, @delimiter)
      else
        @sorted_laptops = get_sorted_laptops_from_text(@laptops)
      end
      if @sorted_laptops
        @good_laptops_count = get_good_laptops_count(@sorted_laptops)
        @bad_laptops_count = get_bad_laptops_count(@sorted_laptops)
      end
    else
      @sorted_laptops = []
    end
  end
end

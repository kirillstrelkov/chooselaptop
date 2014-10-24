class LaptopsController < ApplicationController
  include LaptopsHelper
  def index
    # TODO add url to CPU and GPU to correct indecies
    @laptops = params[:laptops]
    delimiter = params[:delimiter]
    if delimiter.nil? or delimiter.length == 0
      @delimiter = nil
    else
      @delimiter = delimiter.strip
    end
    @use_delimiter = params[:use_delimiter] == 'yes' ? true : false
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

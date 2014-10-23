class LaptopController < ApplicationController
  include LaptopHelper
  def index
    delimiter = params[:delimiter]
    if delimiter.nil? or delimiter.length == 0
      @delimiter = nil
    else
      @delimiter = delimiter
    end

    @use_delimiter = params[:use_delimiter] == 'true' ? true : false
    
    @sorted_laptops = []
  end
  
  def sort
    @laptops = params[:laptops].nil? ? [] : params[:laptops]
    delimiter = params[:delimiter]
    if delimiter.nil? or delimiter.length == 0
      @delimiter = nil
    else
      @delimiter = delimiter.strip
    end
    @use_delimiter = params[:use_delimiter] == 'yes' ? true : false

    if @use_delimiter
      @sorted_laptops = get_sorted_laptops_from_text(@laptops, @delimiter)
    else
      @sorted_laptops = get_sorted_laptops_from_text(@laptops)
    end
    render :index
  end
end

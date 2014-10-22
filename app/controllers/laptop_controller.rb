class LaptopController < ApplicationController
  include LaptopHelper
  def index
    @sorted_laptops = []
  end
  
  def sort
    @laptops = params[:laptops]
    @sorted_laptops = get_sorted_laptops_from_text(@laptops)
    render :index
  end
end

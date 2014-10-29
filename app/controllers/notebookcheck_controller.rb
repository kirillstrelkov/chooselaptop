require 'open-uri'
class NotebookcheckController < ApplicationController
  include NotebookcheckHelper
  def cpus
    all_data = get_all_cpu_data_from_notebookcheck
    respond_to do |format|
      format.json {render :json => all_data}
      format.html
    end
  end

  def gpus
    all_data = get_all_gpu_data_from_notebookcheck
    respond_to do |format|
      format.json {render :json => all_data}
      format.html
    end
  end
  
  def get_cpu
    cpu_name = params[:name]
    cpu_data = get_cpu_data_from_notebookcheck cpu_name
    respond_to do |format|
      format.json {render :json => cpu_data}
    end
  end
  
  def get_gpu
    gpu_name = params[:name]
    gpu_data = get_gpu_data_from_notebookcheck gpu_name
    respond_to do |format|
      format.json {render :json => gpu_data}
    end
  end
end

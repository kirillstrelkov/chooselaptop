# encoding: utf-8
module LaptopHelper
  include TextParser
  include NotebookcheckHelper
  @@delimiter = /\n{2,}/

  def get_sorted_laptops(laptops)
    all_cpu_data = get_all_cpu_data_from_notebookcheck
    all_gpu_data = get_all_gpu_data_from_notebookcheck
    # TODO remove upper two line
    sorted_laptops = []
    laptops.each do |laptop_desc|
      laptop_desc.strip!
      if laptop_desc.length != 0
        cpu = get_cpu_from_text(laptop_desc)
        gpu = get_gpu_from_text(laptop_desc)
        price = get_price_from_text(laptop_desc)
  
        # TODO replace with get_cpu_data_from_notebookcheck(cpu)
        cpu_data = get_cpu_or_gpu_data_from_notebookcheck(cpu, all_cpu_data)
        # TODO replace with get_gpu_data_from_notebookcheck(gpu)
        gpu_data = get_cpu_or_gpu_data_from_notebookcheck(gpu, all_gpu_data)
        if cpu_data[:index] != -1 and gpu_data[:index] != -1
          avg_index = ((cpu_data[:index] + gpu_data[:index]) / 2.0).to_i
        else
          avg_index = -1
        end
  
        sorted_laptops << {
          :cpu_model => cpu_data[:name],
          :cpu_index => cpu_data[:index],
          :gpu_model => gpu_data[:name],
          :gpu_index => gpu_data[:index],
          :avg_index => avg_index,
          :desc => laptop_desc,
          :price => price
        }
      end
    end

    sorted_laptops.sort_by do |hash|
      [hash[:avg_index], hash[:cpu_index], hash[:gpu_index], hash[:price]]
    end
  end

  def get_sorted_laptops_from_text(text, delimiter=nil)
    if delimiter.nil?
      delimiter = @@delimiter
    end
    text.delete!("\r")
    get_sorted_laptops(text.split(delimiter).compact.uniq)
  end
end

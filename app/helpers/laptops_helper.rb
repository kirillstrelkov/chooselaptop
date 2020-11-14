# frozen_string_literal: true

module LaptopsHelper
  include TextParser
  include NotebookcheckHelper
  DEFAULT_TITLE = 'Choose best laptop between several ones'
  DEFAULT_DESC = "If you are tired of comparing multiple laptops' features and don't know which one to choose. This site will try to help you by sorting entered laptop by CPU/GPU rating and price. Functionality is based on CPU/GPU benchmarks from https://www.notebookcheck.net/ web site."
  @@delimiter = /\n{2,}/
  TOP_VALUE = 101

  def get_sorted_laptops(laptops)
    all_cpu_data = get_all_cpu_data_from_notebookcheck
    all_gpu_data = get_all_gpu_data_from_notebookcheck
    sorted_laptops = []
    laptops.each do |laptop_desc|
      laptop_desc = laptop_desc.strip
      next if laptop_desc.empty?

      cpu = get_cpu_from_text(laptop_desc)
      gpu = get_gpu_from_text(laptop_desc)
      price = get_price_from_text(laptop_desc)

      cpu_data = get_cpu_or_gpu_data_from_notebookcheck(cpu, all_cpu_data)
      gpu_data = get_cpu_or_gpu_data_from_notebookcheck(gpu, all_gpu_data)

      avg_percentage = TOP_VALUE
      cpu_perc = cpu_data[:percentage]
      gpu_perc = gpu_data[:percentage]
      avg_percentage = (cpu_perc + gpu_perc) / 2.0 if !cpu_perc.nil? && \
                                                      !gpu_perc.nil? && \
                                                      cpu_perc > -1 && \
                                                      gpu_perc > -1

      sorted_laptops << {
        cpu_model: cpu_data[:name],
        cpu_model_href: cpu_data[:href],
        cpu_percentage: cpu_perc || TOP_VALUE,
        gpu_model: gpu_data[:name],
        gpu_model_href: gpu_data[:href],
        gpu_percentage: gpu_perc || TOP_VALUE,
        avg_percentage: avg_percentage,
        desc: laptop_desc,
        price: price
      }
    end

    sorted_laptops.sort_by do |hash|
      [-hash[:avg_percentage], -hash[:cpu_percentage], -hash[:gpu_percentage], hash[:price]]
    end
  end

  def get_sorted_laptops_from_text(text, delimiter = nil)
    delimiter = @@delimiter if delimiter.nil?
    text = text.delete("\r")
    get_sorted_laptops(text.split(delimiter).compact.uniq)
  end

  def get_good_laptops_count(sorted_laptops)
    sorted_laptops.reject { |laptop| (laptop[:cpu_percentage] == TOP_VALUE) || (laptop[:gpu_percentage] == TOP_VALUE) }.length
  end

  def get_bad_laptops_count(sorted_laptops)
    sorted_laptops.select { |laptop| (laptop[:cpu_percentage] == TOP_VALUE) || (laptop[:gpu_percentage] == TOP_VALUE) }.length
  end
end

require 'open-uri'
require 'nokogiri'

module NotebookcheckHelper
  @@bad_data = {:name => 'unknown', :index => -1}
  def get_data_from_url(url)
    doc = Nokogiri::HTML(open(url))
    xpath_row  = "//div[@id='content']//table//tr[@class='odd' or @class='even']"
    xpath_index = "./td[1]"
    xpath_name = "./td[2]"

    data = []
    doc.xpath(xpath_row).each do |row|
      index = row.xpath(xpath_index).text().match(/\d+/).to_s.to_i
      name = row.xpath(xpath_name).text()
      data << {
        :name => name,
        :index => index
      }
    end

    data
  end

  def get_all_cpu_data_from_notebookcheck
    url = "http://www.notebookcheck.net/Mobile-Processors-Benchmarklist.2436.0.html"
    get_data_from_url(url)
  end

  def get_all_gpu_data_from_notebookcheck
    url = "http://www.notebookcheck.net/Mobile-Graphics-Cards-Benchmark-List.844.0.html"
    get_data_from_url(url)
  end
  
  def get_cpu_data_from_notebookcheck(cpu)
    get_cpu_or_gpu_data_from_notebookcheck(cpu, get_all_cpu_data_from_notebookcheck)
  end
  
  def get_gpu_data_from_notebookcheck(gpu)
    get_cpu_or_gpu_data_from_notebookcheck(gpu, get_all_gpu_data_from_notebookcheck)
  end
  
  def get_cpu_or_gpu_data_from_notebookcheck(cpu_or_gpu, data_from_notebookcheck)
    unless cpu_or_gpu.nil?
      manufacturer = cpu_or_gpu.split[0]
      model = cpu_or_gpu.split[-1]
      data_from_notebookcheck.each do |data|
        name = data[:name]
        index = data[:index]
        lowered_name = name.downcase
        if manufacturer == lowered_name.split[0] and lowered_name.split[-1].end_with?(model)
          return {:name => name, :index => index}
        end
      end
    end
    @@bad_data
  end
end

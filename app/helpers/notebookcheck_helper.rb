require 'open-uri'
require 'nokogiri'

module NotebookcheckHelper
  def get_info_from_url(url)
    doc = Nokogiri::HTML(open(url))
    indecies_url = "//div[@id='content']//table//tr[@class='odd' or @class='even']/td[1]"
    names_url = "//div[@id='content']//table//tr[@class='odd' or @class='even']/td[2]"

    names = doc.xpath(names_url).map{|n| n.text()}
    indecies = doc.xpath(indecies_url).map{|i| i.text().match(/\d+/).to_s.to_i}

    Hash[names.zip(indecies)]
  end

  def get_cpu_sorted_names
    url = "http://www.notebookcheck.net/Mobile-Processors-Benchmarklist.2436.0.html"
    get_info_from_url(url)
  end

  def get_gpu_sorted_names
    url = "http://www.notebookcheck.net/Mobile-Graphics-Cards-Benchmark-List.844.0.html"
    get_info_from_url(url)
  end
end

# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module NotebookcheckHelper
  @@bad_data = { name: 'Not found', index: 101, href: nil }
  @@cpu_url = 'https://www.notebookcheck.net/Mobile-Processors-Benchmark-List.2436.0.html?&deskornote=2&or=0&cpu_fullname=1&cores=1&threads=1'
  @@gpu_url = 'https://www.notebookcheck.net/Mobile-Graphics-Cards-Benchmark-List.844.0.html?multiplegpus=1&or=0&gpu_fullname=1'
  def get_data_from_url(url)
    doc = Nokogiri::HTML(open(url))
    xpath_row = "//div[@id='content']//table//tr[@class='odd' or @class='even']"
    xpath_index = './td[1]'
    xpath_name = './td[2]'

    data = []
    doc.xpath(xpath_row).each do |row|
      index = row.xpath(xpath_index).text.match(/\d+/).to_s.to_i
      name = row.xpath(xpath_name).text
      href = row.xpath(xpath_name).xpath('./a/@href').text
      data << {
        name: name,
        index: index,
        href: href
      }
    end

    data
  end

  def get_all_cpu_data_from_notebookcheck
    get_data_from_url(@@cpu_url)
  end

  def get_all_gpu_data_from_notebookcheck
    get_data_from_url(@@gpu_url)
  end

  def get_cpu_data_from_notebookcheck(cpu)
    get_cpu_or_gpu_data_from_notebookcheck(cpu, get_all_cpu_data_from_notebookcheck)
  end

  def get_gpu_data_from_notebookcheck(gpu)
    get_cpu_or_gpu_data_from_notebookcheck(gpu, get_all_gpu_data_from_notebookcheck)
  end

  def get_cpu_or_gpu_data_from_notebookcheck(cpu_or_gpu, data_from_notebookcheck)
    unless cpu_or_gpu.nil?
      regexp = /\w+/
      max_index = data_from_notebookcheck.last[:index]
      best_data = @@bad_data
      min_diff = 100
      data_from_notebookcheck.each do |data|
        name = data[:name]
        has_all_words_in_name = (cpu_or_gpu.downcase.scan(regexp) - name.downcase.scan(regexp)).empty?
        next unless has_all_words_in_name

        diff = (name.downcase.scan(regexp) - cpu_or_gpu.downcase.scan(regexp)).length
        if diff < min_diff
          min_diff = diff
          best_data = data
        end
      end
      return @@bad_data if min_diff == 100

      return { name: best_data[:name],
               href: best_data[:href],
               percentage: 1 - best_data[:index].to_f / max_index }
    end
    @@bad_data
  end
end

require 'test_helper'

class NotebookcheckHelperTest < ActionView::TestCase
  include NotebookcheckHelper
  include TextParser
  def test_get_cpu_sorted_names
    data = get_all_cpu_data_from_notebookcheck
    assert_not_equal('unknown', data[0][:name])
    assert_not_equal(-1, data[0][:index])
    assert_not_nil(data[0][:href])
  end

  def test_get_gpu_sorted_names
    data = get_all_gpu_data_from_notebookcheck
    assert_not_empty data
    assert_not_equal('unknown', data[0][:name])
    assert_not_equal(-1, data[0][:index])
    assert_not_nil(data[0][:href])
  end

  def test_get_cpu_from_notebookcheck
    assert_equal("Intel Core i5-4210M", get_cpu_data_from_notebookcheck("intel 4210m")[:name])
  end

  def test_get_cpu_from_notebookcheck2
    assert_equal("Intel Core i3-3217U", get_cpu_data_from_notebookcheck("intel 3-3217u")[:name])
  end

  def test_get_gpu_from_notebookcheck
    assert_equal("NVIDIA GeForce GT 720M", get_gpu_data_from_notebookcheck("nvidia 720m")[:name])
  end

  def test_get_bad_gpu_and_bad_cpu_from_notebookcheck
    data = get_cpu_data_from_notebookcheck("sdfsdf")
    assert_equal("unknown", data[:name])
    assert_equal(@@bad_data, data)
    
    data = get_gpu_data_from_notebookcheck("sdfsdfdsf")
    assert_equal("unknown", data[:name])
    assert_equal(@@bad_data, data)
  end

  def test_parse_all_cpus_from_notebookcheck
    all_data = get_all_cpu_data_from_notebookcheck
    bad_data = []
    all_data.each do |data|
      if get_cpu_from_text(data[:name]).nil?
        bad_data << data[:name]
      end
    end
    good_precentage = (all_data.length - bad_data.length) / all_data.length.to_f * 100
    assert good_precentage.to_i >= 74, "Wasn't parsed, good pretentage #{good_precentage}:\n%s\n" % bad_data.join("\n")
  end

  def test_parse_all_gpus_from_notebookcheck
    all_data = get_all_gpu_data_from_notebookcheck
    bad_data = []
    all_data.each do |data|
      if get_gpu_from_text(data[:name]).nil?
        bad_data << data[:name]
      end
    end
    good_precentage = (all_data.length - bad_data.length) / all_data.length.to_f * 100
    assert good_precentage.to_i >= 79, "Wasn't parsed, good pretentage #{good_precentage}:\n%s\n" % bad_data.join("\n")
  end
end

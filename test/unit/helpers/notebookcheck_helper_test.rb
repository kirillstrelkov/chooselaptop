# frozen_string_literal: true

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

  def test_get_cpu
    assert_equal('Intel Core i5-4210M', get_cpu_data_from_notebookcheck('intel 4210m')[:name])
  end

  def test_get_cpu2
    assert_equal('Intel Core i3-3217U', get_cpu_data_from_notebookcheck('intel i3-3217u')[:name])
  end

  def test_gpu_intel_hd
    assert_equal('Intel HD Graphics 620', get_gpu_data_from_notebookcheck('intel hd 620')[:name])
  end

  def test_gpu_intel_uhd
    assert_equal('Intel UHD Graphics 620', get_gpu_data_from_notebookcheck('intel uhd 620')[:name])
  end

  def test_old_get_gpu
    assert_equal('NVIDIA GeForce 610M', get_gpu_data_from_notebookcheck('nvidia 610M')[:name])
  end

  def test_get_gpu
    assert_equal('NVIDIA GeForce GT 720M', get_gpu_data_from_notebookcheck('nvidia 720m')[:name])
  end

  def test_get_gpu_amd
    assert_equal('AMD Radeon RX Vega 10', get_gpu_data_from_notebookcheck('radeon vega 10')[:name])
    assert_equal('AMD Radeon R7 M440', get_gpu_data_from_notebookcheck('AMD Radeon R7 M440')[:name])
  end

  def test_get_gpu_close_name
    assert_equal('NVIDIA GeForce GTX 1050 Mobile', get_gpu_data_from_notebookcheck('geforce 1050')[:name])
    assert_equal('NVIDIA GeForce GTX 1050 Ti Mobile', get_gpu_data_from_notebookcheck('geforce 1050 ti')[:name])
  end

  def test_get_gpu_rtx
    assert_equal('NVIDIA GeForce RTX 3060 Laptop GPU',
                 get_gpu_data_from_notebookcheck('GeForce RTX 3060')[:name])
    assert_equal('NVIDIA GeForce RTX 3050 Ti Laptop GPU',
                 get_gpu_data_from_notebookcheck('GeForce RTX 3050 Ti')[:name])
  end

  def test_get_bad_gpu_and_bad_cpu
    data = get_cpu_data_from_notebookcheck('sdfsdf')
    assert_equal('Not found', data[:name])
    assert_equal(@@bad_data, data)

    data = get_gpu_data_from_notebookcheck('sdfsdfdsf')
    assert_equal('Not found', data[:name])
    assert_equal(@@bad_data, data)
  end

  def test_parse_all_cpus
    all_data = get_all_cpu_data_from_notebookcheck
    bad_data = []
    all_data.each do |data|
      bad_data << data[:name] if get_cpu_from_text(data[:name]).nil?
    end
    good_precentage = (all_data.length - bad_data.length) / all_data.length.to_f * 100
    assert good_precentage.to_i >= 74,
           format("Wasn't parsed, good pretentage #{good_precentage}:\n%s\n", bad_data.join("\n"))
  end

  def test_parse_all_gpus
    all_data = get_all_gpu_data_from_notebookcheck
    bad_data = []
    all_data.each do |data|
      bad_data << data[:name] if get_gpu_from_text(data[:name]).nil?
    end
    good_precentage = (all_data.length - bad_data.length) / all_data.length.to_f * 100
    assert good_precentage.to_i >= 77,
           format("Wasn't parsed, good pretentage #{good_precentage}:\n%s\n", bad_data.join("\n"))
  end
end

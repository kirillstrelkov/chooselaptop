require 'test_helper'

class NotebookcheckHelperTest < ActionView::TestCase
  include NotebookcheckHelper
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
  
  def test_get_gpu_from_notebookcheck
    assert_equal("NVIDIA GeForce GT 720M", get_gpu_data_from_notebookcheck("nvidia 720m")[:name])
  end
  
  def test_get_bad_gpu_and_bad_cpu_from_notebookcheck
    assert_equal("unknown", get_cpu_data_from_notebookcheck("sdfsdf")[:name])
    assert_equal("unknown", get_gpu_data_from_notebookcheck("sdfsdfdsf")[:name])
  end
  
end

require 'test_helper'

class NotebookcheckHelperTest < ActionView::TestCase
  include NotebookcheckHelper
  def test_get_cpu_sorted_names
    assert_not_empty get_cpu_sorted_names
  end

  def test_get_gpu_sorted_names
    assert_not_empty get_gpu_sorted_names
  end
end

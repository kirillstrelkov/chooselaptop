# encoding: utf-8
require 'test_helper'

class LaptopHelperTest < ActionView::TestCase
  include LaptopHelper
  def test_get_sorted_laptops
    laptops = [%Q[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...],
      %Q[15.6" hd (1366x768), intel core i5-4200m 2.50ghz, 6gb (2gb+4gbddriii1600), 1tb 5400rpm, amd radeon hd 8750m 2gb, sm dvd+-rw, dos, Беспроводной  802.11 b/g/...]]
    sorted_laptops = get_sorted_laptops(laptops)
    first_laptop = sorted_laptops[0]
    second_laptop = sorted_laptops[1]
    assert_kind_of(Hash, first_laptop)
    assert(first_laptop[:avg_index] < second_laptop[:avg_index], "Laprops are incorrectly sorted")
    assert_equal('Intel Core i5-4200M', first_laptop[:cpu_model])
    assert_equal('AMD Radeon HD 8750M', first_laptop[:gpu_model])
  end

  def test_get_sorted_laptops_2
    laptops = %Q{Acer Aspire E1-731 NX.MGAEL.002
17.3" HD+ (1600X900), Intel Pentium 2020M, 2.4GHz, Intel HD Graphics, 4GB, SATA 500GB, DVD Super Multi DL, WLAN 802.11 b/g/n, Linpus Linux, WebCam, HD...
349.00 EUR

Acer Aspire E1-771G NX.MG6EL.005
17.3" HD+ (1600X900), Intel Core i3-3110M 2.3GHz, NVIDIA GeForce 710M 2GB, 4GB, SATA 500GB, DVD Super Multi DL, WLAN 802.11 b/g/n, Linpus Linux, WebCa...
447.00 EUR

Lenovo IdeaPad G510A 59-402568
15.6" HD (1366x768), Intel Core i5-4200M 2.50GHz, 6GB (2GB+4GBDDRIII1600), 1TB 5400rpm, AMD Radeon HD 8750M 2GB, SM DVD+-RW, Dos, Wireless 802.11 b/g/...
491.00 EUR
}
    sorted_laptops = get_sorted_laptops_from_text(laptops)
    assert_equal(sorted_laptops.length, 3)
    laptops = laptops.split(/\n{2,}/)
    sorted_laptops = get_sorted_laptops(laptops)
    assert_equal(sorted_laptops.length, 3)
  end
end

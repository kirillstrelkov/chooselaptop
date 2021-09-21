# frozen_string_literal: true

require 'test_helper'

class LaptopsHelperTest < ActionView::TestCase
  include LaptopsHelper
  def test_get_sorted_laptops
    laptops = [%[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...],
               %[15.6" hd (1366x768), intel core i5-4200m 2.50ghz, 6gb (2gb+4gbddriii1600), 1tb 5400rpm, amd radeon vega 10, sm dvd+-rw, dos, Беспроводной  802.11 b/g/...]]
    sorted_laptops = get_sorted_laptops(laptops)
    first_laptop = sorted_laptops[0]
    second_laptop = sorted_laptops[1]
    assert_kind_of(Hash, first_laptop)
    assert(first_laptop[:avg_percentage] > second_laptop[:avg_percentage], 'Laprops are incorrectly sorted')
    assert_equal('Intel Core i5-4200M', first_laptop[:cpu_model])
    assert_equal('AMD Radeon RX Vega 10', first_laptop[:gpu_model])
  end

  def test_get_sorted_laptops_2
    laptops = %{Acer Aspire E1-731 NX.MGAEL.002
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

  def test_rtx_laptop
    laptops = [%[Display: 16", 3072x1920, 226ppi, 60Hz, non-glare, 300cd/m², 1000:1 • CPU: Intel Core i5-11400H, 6C/12T, 2.20-4.50GHz, 12MB+8MB Cache, 35-45W TDP, Codename "Tiger Lake-H45" (Willow Cove, 10nm SuperFin) • RAM: 16GB DDR4-3200 (2x 8GB Module, 2 ... (zu wenige) 90 aus 1 Test 3 ab € 1249,00 [DE] Cyberport Stores Deutschland und 2 weitere Händler HP Victus 16-d0065ng Mica Silver, Core i7-11800H, 16GB RAM, 512GB SSD, GeForce RTX 3050 Ti, DE (4H3E6EA#ABD) HP Victus 16-d0065ng Mica Silver, Core i7-11800H, 16GB RAM, 512GB SSD, GeForce RTX 3050 Ti, DE (4H3E6EA#ABD)],
               %[OMEN 16-c0253ng Gaming-Notebook (40,9 cm/16,1 Zoll, AMD Ryzen 5, GeForce RTX™ 3050 Ti, 512 GB SSD, Kostenloses Upgrade auf Windows 11, sobald verfügbar)]]
    sorted_laptops = get_sorted_laptops(laptops)

    laptop = sorted_laptops.first
    assert_kind_of(Hash, laptop)
    assert_equal('AMD Ryzen 5 5600H', laptop[:cpu_model])
    assert_equal('NVIDIA GeForce RTX 3050 Ti Laptop GPU', laptop[:gpu_model])

    laptop = sorted_laptops.second
    assert_kind_of(Hash, laptop)
    assert_equal('Intel Core i5-11400H', laptop[:cpu_model])
    assert_equal('NVIDIA GeForce RTX 3050 Ti Laptop GPU', laptop[:gpu_model])
  end
end

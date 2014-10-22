# encoding: utf-8
require 'test_helper'

class LaptopHelperTest < ActionView::TestCase
  include LaptopHelper
=begin
# generates Hash for cpu and gpu

class GenerateHashes < Test::Unit::TestCase
@@parser =  Parser.new
@@laptops = IO.readlines('laptops_descs.csv')
def test_generate_cpus
puts "{"
@@laptops.each do |laptop|
cpu = @@parser.get_cpu(laptop)
puts %Q{%Q[#{laptop.strip}] => "#{cpu}",}
end
puts "}"
end
def test_generate_gpus
puts "{"
@@laptops.each do |laptop|
gpu = @@parser.get_gpu(laptop)
puts %Q{%Q[#{laptop.strip}] => "#{gpu}",}
end
puts "}"
end
end
=end
  def test_get_cpu_single
    data = %Q[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...]
    assert_equal(get_cpu(data), "intel 4210m")
  end

  def test_get_cpu
    data = {
      %Q[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...] => "intel 4210m",
      %Q[15.6" hd (1366x768), intel core i5-4200m 2.50ghz, 6gb (2gb+4gbddriii1600), 1tb 5400rpm, amd radeon hd 8750m 2gb, sm dvd+-rw, dos, Беспроводной  802.11 b/g/...] => "intel 4200m",
      %Q[15.6" hd trubrite led (1366x768), intel core i5-4200m 2.5ghz/3mb, nvidia gt 710m 2gb, 4gb ddr3-1600mhz, sata 750gb 5400rpm, sm dl dvd+/-rw, wlan 802.1...] => "intel 4200m",
      %Q[15.6" hd trubrite led (1366x768), intel core i5-4200m 2.5ghz/3mb, nvidia geforce 710m 2gb, 4+4gb ddr3-1600mhz, sata 1tb 5400rpm, sm dl dvd+/-rw, wlan...] => "intel 4200m",
      %Q[15.6" hd 1366x768 led, intel core i5-3230m 2.6 ghz, nvidia geforce 820m 1gb, 4gb ddr3l, 500gb 5400rpm, dvd super multi dl, wlan 802.11b/g/n + bluetoot...] => "intel 3230m",
      %Q[15.6" hd (1366x768) led glare, intel core i7-4510u 2.0ghz, 4gb ddr3l, 1tb 5400rpm, ati radeon r5 m230 2gb, sm dvd+-rw, 802.11b/g/n + bluetooth4.0, 4 c...] => "intel 4510u",
      %Q[15,6" (1366x768) glare, intel core i5-2430m 2.40 ghz, 4gb 1066mhz, 640gb 5400rpm, nvidia geforce gt 520m 1gb, dvd+/-rw supermulti dl, wlan 802.11b/g/n...] => "intel 2430m",
      %Q[17.3" (1600x900) led glossy hd+, intel core i3-4000m 2.4ghz, 4gb ddr3-1600, nvidia geforce gt 745m 2gb, 1tb 5400rpm, sm dvd+-rw, dos, wlan 802.11b/g/n...] => "intel 4000m",
      %Q[17.3" (1600x900) led glare hd+, intel core i3-4000m 2.4ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...] => "intel 4000m",
      %Q[15.6" hd (1366x768) anti-glare led, intel core i3 4000m 2.4ghz/3mb, 1x4gb ddr3-1600, 500g b 5400rpm, intel hd, dvd±rw dl, wlan 802.11b/g/n, bluetooth...] => "intel 4000m",
      %Q[15.6" wxga (1366x768) led glossy, intel core i3-3110m 2.40ghz, 4gb ddr3-1600, 1tb 5400rpm, amd radeon hd 8570m 1gb, sm dvd+-rw, dos, wlan 802.11b/g/n,...] => "intel 3110m",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-3110m 2.4ghz/3mb, nvidia geforce gt 710m 2gb, 4gb ddr3-1600mhz, sata 750gb 5400rpm, sm dl dvd+/-rw, wl...] => "intel 3110m",
      %Q[17.3" hd+ (1600x900), intel core i3-3110m 2.3ghz, nvidia geforce 710m 2gb, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, linpus linux, webca...] => "intel 3110m",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-3110m 2.4ghz/3mb, nvidia geforce gt 710m 1gb, 4gb ddr3-1600mhz, sata 750gb 5400rpm, sm dl dvd+/-rw, wl...] => "intel 3110m",
      %Q[15.6" wxga (1366x768) led, intel core i3-3110m 2.40ghz, 4gb ddr3-1600, 1tb 5400rpm, intel hd graphics 4000, sm dvd+-rw, dos, wlan 802.11b/g/n, bluetoo...] => "intel 3110m",
      %Q[15.6" hd (1366x768) antiglare, intel core i3-3110m 2.4ghz/3mb, hd graphics 4000, 1x4gb ddr3-1600, 500gb 5400rpm, dvd±rw dl, dos, 802.11b/g/n, bt, 2xus...] => "intel 3110m",
      %Q[17.3" hd+ (1600x900) led glare, intel core i3-3110m 2.4ghz, nvidia geforce gt720 2gb, 4gb, 1tb 5400rpm, dvd super multi, webcam, wifi, sd/mmc, dos, 2....] => "intel 3110m",
      %Q[15.6" hd 1366x768 led glare, intel core i5-4210u 1.7ghz/3mb, nv geforce gt 840m/2gb 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n +...] => "intel 4210u",
      %Q[15.6" led (1366x768), intel core i5-4210u 1.7ghz, 4gb ddr3, 1tb Жесткий диск, nvidia geforce 840m 2gb, dvd super multi, wi-fi 802.11b/g/n, bluetooth, 1xhdmi, 1...] => "intel 4210u",
      %Q[15.6" led (1366x768) non-glare, intel core i5-4210u 1.7ghz, 4gb ddr3, 1tb Жесткий диск, nvidia geforce 840m 2gb, dvd super multi, wi-fi 802.11b/g/n, bluetooth,...] => "intel 4210u",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), amd radeon hd r7 m265 2gb ddr3, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400r...] => "intel 4210u",
      %Q[15.6" led (1366x768) non-glare, intel core i5-4210u 1.7ghz, 4gb ddr3, 1tb Жесткий диск, nvidia geforce 820m 1gb, dvd super multi, wi-fi 802.11b/g/n, bluetooth,...] => "intel 4210u",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, t...] => "intel 4210u",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, t...] => "intel 4210u",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 1tb 5400rpm, tra...] => "intel 4210u",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 1tb 5400rpm, tra...] => "intel 4210u",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 1tb 5400rpm, tra...] => "intel 4210u",
      %Q[13.3" hd anti-glare, intel core i5-4210u 1.7ghz/3mb, 4gb ram, 500gb Жесткий диск, intel hd graphics, non-intel 1x1 b/g/n + bt, ethernet, 2in1 Кардридер, 4 ce...] => "intel 4210u",
      %Q[15.6" hd (1366x768) ag, intel core i5-4210u Процессор 2.7ghz/3mb, 4gb ddr3, 500gb 5400rpm, intel hd graphics, non-intel 1x1 b/g/n+bt4.0, dvd±rw, 4cell...] => "intel 4210u",
      %Q[15.6" hd (1366x768), intel core i5-4200u 1.60ghz, amd radeon r7 m265 2gb, 4gb, sata 1tb, dvd super multi dl, wlan 802.11 b/g/n, microsoft windows 8.1,...] => "intel 4200u",
      %Q[15.6" hd (1366x768), intel core i5-4200u 1.60ghz, amd radeon r7 m265 2gb, 8gb, sata 1tb 5400rpm, dvd super multi dl, wlan 802.11 b/g/n, microsoft wind...] => "intel 4200u",
      %Q[15.6" hd 1366x768 led anti-glare, intel core i5-4200u 1.6ghz/3mb, intel hd 4000, 4gb ddr3-1600, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + b...] => "intel 4200u",
      %Q[17.3"(1600x900) led glare hd+, intel pentium 3550m 2.3ghz, 4gb ddr3-1600, nvidia geforce gt 720m 2gb, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, ca...] => "intel 3550m",
      %Q[17.3" hd+ (1600x900), intel pentium 2020m, 2.4ghz, intel hd graphics, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, linpus linux, webcam, hd...] => "intel 2020m",
      %Q[15.6" led (1366x768) non-glare, intel core i3-4030u 1.90 mhz, 4gb, 500gb 5400rpm, nvidia geforce 840m 2gb, dvd super multi, wlan 802.11b/g/n +bluetoot...] => "intel 4030u",
      %Q[15.6" wxga (1366x768) non-glare, intel core i3-4030u 1.9ghz, nvidia geforce 820m 1gb, 4gb, sata 500gb 5400rpm, wlan 802.11b/g/n, linux, 1xusb 3.0/2x u...] => "intel 4030u",
      %Q[17.3" glare hd+ (1600x900) led glare, intel core i3-4030u (1.9ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm,...] => "intel 4030u",
      %Q[15.6" led (1366x768) matte, intel core i3-4030u, 4gb ddr3, 500gb Жесткий диск, intel hd graphics 4400, Общий vram, dvd sm, bgn, bt, hdmi, 4 cell batt., hd cam...] => "intel 4030u",
      %Q[15.6" wxga (1366x768) non-glare, intel core i3-4030u 1.9ghz, intel hd graphics 4400, 4gb, sata 500gb 5400rpm, wlan 802.11b/g/n, linux, 3xusb, sd card...] => "intel 4030u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4030u (1.9ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm hybrid Жесткий диск ,...] => "intel 4030u",
      %Q[15.6" hd (1366x768)С антибликовым покрытием, intel core i3-4030u 1.90ghz, intel hd graphics 4400, 4gb, sata 500gb, dvd super multi, wlan 802.11 b/g/n, windows 8.1,...] => "intel 4030u",
      %Q[17.3" glare hd+ (1600x900) led glare, intel core i3-4030u (1.9ghz/3mb), intel hd4400 graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray loa...] => "intel 4030u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4030u 1.9ghz/3mb, 4gb ddr3-1600, 500gb 5400rpm, integrated graphics, sm dvd+-rw, non-intel 1x1 b/g/n + bt...] => "intel 4030u",
      %Q[15.6" hd 1366x768 led glare, intel core i3-4030u 1.9ghz/3mb, nv gt820m/2gb, 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + bluetoot...] => "intel 4030u",
      %Q[13.3" hd anti-glare, intel core i3-4030u 1.9ghz/3mb, 4gb ram, 500gb Жесткий диск, intel hd graphics, non-intel 1x1 b/g/n + bt, ethernet, 2in1 Кардридер, 4 ce...] => "intel 4030u",
      %Q[15.6" hd 1366x768 led anti-glare, intel core i3-4010u 1.7ghz/3mb, intel hd 4400, 4gb ddr3-1600, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + b...] => "intel 4010u",
      %Q[14.0" hd (1366x768)С антибликовым покрытием wled, intel core i3-4010u (1.7ghz/3mb), intel hd 4400, 4gb (1x4gb) ddr3l-1600mhz, 500gb 5400rpm sata Жесткий диск, Внутри / Нет...] => "intel 4010u",
      %Q[15.6" hd 1366x768 led glare, intel core i3-4010u 1.7ghz/3mb, nvidia gt820m/2gb, 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + Синий...] => "intel 4010u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4005u",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, intel hd, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth...] => "intel 4005u",
      %Q[15.6" led (1366x768) matte, intel i3-4005u, 4gb, 1tb, dvd, intel hd, blutooth, hdmi, usb 3.0, sd reader, cam, linux, iron, eng-rus kbd] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u (1.7 ghz), intel hd, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, b...] => "intel 4005u",
      %Q[15.6" led (1366x768) non-glare, intel core i3-4005u, 4gb, 1tb, nvidia geforce 820 1gb, dvd, bluetooth, hdmi, usb 3.0, sd reader, cam, linux, Черный, en...] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, intel hd, 4gb ddr3l (1600mhz), sata 1tb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, bluetooth 4.0...] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, intel hd, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, bluetooth 4...] => "intel 4005u",
      %Q[15.6" hd (1366x768) ag, intel core i3-4005u Процессор 1.7ghz/3mb, 4gb ddr3, 500gb 5400rpm, intel hd graphics, non-intel 1x1 b/g/n+bt4.0, dvd±rw, 4cell...] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => "intel 4005u",
      %Q[15.6" fhd trubrite led (1920x1080), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1x...] => "intel 4005u",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => "intel 4005u",
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), intel hd4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, wlan 802.11...] => "intel 3217u",
      %Q[15.6" hd 1366x768 led, intel core i3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск/ bt4.0/ bgn/ 4 cell batt./ hd камера/ usb 3.0/ Черный/ linpus...] => "intel 3217u",
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), hd 4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, bluetooth, wlan...] => "intel 3217u",
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), hd 4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, bluetooth, wlan...] => "intel 3217u",
      %Q[15.6" hd 1366x768 led glare, intel core i3-3217u 1.8 ghz/3mb, geforce gt710 1gb, 4gb ddr3, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + blueto...] => "intel 3217u",
      %Q[15.6" hd 1366x768 led glare, intel core i3-3217u 1.8ghz, nvidia geforce gt710 1gb, 4gb ddr3, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + Синий...] => "intel 3217u",
      %Q[15.6" hd (1366x768) led glare, amd a6-6310 apu quad-core, amd radeon hd r5 m230 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, Беспроводной ...] => "amd a6-6310",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "intel 3558u",
      %Q[17.3" glare hd+ (1600x900) led glare, pentium 3558u (1.7ghz/2mb), intel hd4000 graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802.11b/g/...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802.11b/g/...] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => "intel 3558u",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => "intel 3558u",
      %Q[15.6" led (1366x768) cinecrystal , intel pentium 3556u , 4gb ddr3, 1tb Жесткий диск, nvidia geforce 820m 1gb, dvd sm, 802.11b/g/n, bt, hdmi, li-ion 6-cell 5000...] => "intel 3556u",
      %Q[17.3" hd+ (1600x900), intel pentium 3556u, 1.7ghz, nvidia geforce 820m 2gb, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, microsoft windows...] => "intel 3556u",
      %Q[13.3" hd (1366x768) led tft, intel pentium 3556u (2m cache, 1.70ghz), 4gb, 500gb, intel hd, bluetooth 4.0, usb3.0, hdmi, linux, aluminium, iron, eng k...] => "intel 3556u",
      %Q[15.6" hd led 1366x768 glare, intel pentium 2117u 1.8ghz, nvidia geforce gt 820m 1gb, 4gb ddr3 500gb Жесткий диск, bt4.0, bgn, 4 cell batt., hd камера, usb 3.0,...] => "intel 2117u",
      %Q[15.6" hd trubrite led (1366x768), intel pentium n3530, intel hd, 4gb ddr3l (1333mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, bluetooth 4...] => "intel n3530",
      %Q[11.6" touch hd (1366x768) led glare (ips), intel pentium n3530 (up to 2.58ghz/2mb), intel hd graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm,...] => "intel n3530",
      %Q[15.6" hd trubrite led (1366x768), intel pentium n3520 2.42ghz/2mb, intel gma, 4gb ddr3-1600mhz, sata 500gb 5400rpm, sm dl dvd+/-rw, wlan 802.11b/g/n,...] => "intel n3520",
      %Q[15.6" hd (1366x768) led glare, amd a4-6210 apu quad-core, amd radeon hd r5 m230 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, Беспроводной ...] => "amd a4-6210",
      %Q[11.6" touch hd led (1366x768) glare, intel atom z3775 1.46ghz/2mb, 2gb, 500gb 5400rpm + 32gb emmc, intel hd / wlan 802.11 a/b/g/n, bluetooth, windows...] => "intel z3775",
      %Q[15.6" hd (1366x768) led glare, intel celeron 2957u (1.4ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm hybrid Жесткий диск , 32gb cache, tra...] => "intel 2957u",
      %Q[15.6" hd (1366x768) led glare, intel celeron 2957u (1.4ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => "intel 2957u",
      %Q[15.6" led 1366x768 wxgag non-glare, intel celeron n2830 2.16ghz, intel hd graphics, 2gb ddr3, 320gb Жесткий диск, bgn, 4-cell battery, webcamera, usb 2.0/usb 3...] => "intel n2830",
      %Q[15.6" hd trubrite led (1366x768), intel celeron n2830, 4gb ddr3l (1333mhz)/ sata 500gb 5400rpm, sm dl dvd+/-rw, wlan 802.11b/g/n, bluetooth 4.0/ ml, /...] => "intel n2830",
      %Q[15.6" led (1366x768)wxgag/ intel celeron n2820 Двухъядерный/ intel hd graphics/ vram shared/ 2gb ddr3/ 320gb Жесткий диск/ bgn/ bt/ usb3.0/ sd reader/ 4 cell batt...] => "intel n2820",
      %Q[15.6" led 1366x768 wxgag non-glare, intel celeron n2815 1.86ghz, intel hd graphics, 2gb ddr3, 320gb Жесткий диск, bgn, 4-cell battery, webcamera, usb 2.0/usb 3...] => "intel n2815",
      %Q[15.6" (1366x768) hd glossy, amd e1-6010 1.35 ghz, 4gb ddr3, 500gb 5400rpm, integrated amd radeon r2 series, wlan 802.11b/g/n +bluetooth 4.0, dvd±rw, 1...] => "amd e1-6010",
      %Q[15.6" led 1366x768 wxgag, intel core 3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск, bgn, bt, 4 cell batt. hd камера, usb 3.0, Черный, microsof...] => nil,
    }
    data.each do |laptop_desc, cpu|
      assert_equal(get_cpu(laptop_desc), cpu)
    end
  end

  def test_get_gpu_no_gpu
    data = %Q[15.6" HD TruBrite LED (1366x768), Intel Celeron N2830, 4GB DDR3L (1333MHz)/ SATA 500GB 5400rpm, SM DL DVD+/-RW, WLAN 802.11b/g/n, Bluetooth 4.0/ ML, /...]
    assert_equal("intel n2830", get_cpu(data))
    assert_equal(nil, get_gpu(data))
  end

  def test_get_gpu
    data = {
      %Q[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...] => "intel 4600",
      %Q[15.6" hd (1366x768), intel core i5-4200m 2.50ghz, 6gb (2gb+4gbddriii1600), 1tb 5400rpm, amd radeon hd 8750m 2gb, sm dvd+-rw, dos, Беспроводной  802.11 b/g/...] => "amd 8750m",
      %Q[15.6" hd trubrite led (1366x768), intel core i5-4200m 2.5ghz/3mb, nvidia gt 710m 2gb, 4gb ddr3-1600mhz, sata 750gb 5400rpm, sm dl dvd+/-rw, wlan 802.1...] => "nvidia 710m",
      %Q[15.6" hd trubrite led (1366x768), intel core i5-4200m 2.5ghz/3mb, nvidia geforce 710m 2gb, 4+4gb ddr3-1600mhz, sata 1tb 5400rpm, sm dl dvd+/-rw, wlan...] => "nvidia 710m",
      %Q[15.6" hd 1366x768 led, intel core i5-3230m 2.6 ghz, nvidia geforce 820m 1gb, 4gb ddr3l, 500gb 5400rpm, dvd super multi dl, wlan 802.11b/g/n + bluetoot...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i7-4510u 2.0ghz, 4gb ddr3l, 1tb 5400rpm, ati radeon r5 m230 2gb, sm dvd+-rw, 802.11b/g/n + bluetooth4.0, 4 c...] => "amd m230",
      %Q[15,6" (1366x768) glare, intel core i5-2430m 2.40 ghz, 4gb 1066mhz, 640gb 5400rpm, nvidia geforce gt 520m 1gb, dvd+/-rw supermulti dl, wlan 802.11b/g/n...] => "nvidia 520m",
      %Q[17.3" (1600x900) led glossy hd+, intel core i3-4000m 2.4ghz, 4gb ddr3-1600, nvidia geforce gt 745m 2gb, 1tb 5400rpm, sm dvd+-rw, dos, wlan 802.11b/g/n...] => "nvidia 745m",
      %Q[17.3" (1600x900) led glare hd+, intel core i3-4000m 2.4ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...] => "intel 4600",
      %Q[15.6" hd (1366x768) anti-glare led, intel core i3 4000m 2.4ghz/3mb, 1x4gb ddr3-1600, 500g b 5400rpm, intel hd, dvd±rw dl, wlan 802.11b/g/n, bluetooth...] => nil,
      %Q[15.6" wxga (1366x768) led glossy, intel core i3-3110m 2.40ghz, 4gb ddr3-1600, 1tb 5400rpm, amd radeon hd 8570m 1gb, sm dvd+-rw, dos, wlan 802.11b/g/n,...] => "amd 8570m",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-3110m 2.4ghz/3mb, nvidia geforce gt 710m 2gb, 4gb ddr3-1600mhz, sata 750gb 5400rpm, sm dl dvd+/-rw, wl...] => "nvidia 710m",
      %Q[17.3" hd+ (1600x900), intel core i3-3110m 2.3ghz, nvidia geforce 710m 2gb, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, linpus linux, webca...] => "nvidia 710m",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-3110m 2.4ghz/3mb, nvidia geforce gt 710m 1gb, 4gb ddr3-1600mhz, sata 750gb 5400rpm, sm dl dvd+/-rw, wl...] => "nvidia 710m",
      %Q[15.6" wxga (1366x768) led, intel core i3-3110m 2.40ghz, 4gb ddr3-1600, 1tb 5400rpm, intel hd graphics 4000, sm dvd+-rw, dos, wlan 802.11b/g/n, bluetoo...] => "intel 4000",
      %Q[15.6" hd (1366x768) antiglare, intel core i3-3110m 2.4ghz/3mb, hd graphics 4000, 1x4gb ddr3-1600, 500gb 5400rpm, dvd±rw dl, dos, 802.11b/g/n, bt, 2xus...] => nil,
      %Q[17.3" hd+ (1600x900) led glare, intel core i3-3110m 2.4ghz, nvidia geforce gt720 2gb, 4gb, 1tb 5400rpm, dvd super multi, webcam, wifi, sd/mmc, dos, 2....] => "nvidia gt720",
      %Q[15.6" hd 1366x768 led glare, intel core i5-4210u 1.7ghz/3mb, nv geforce gt 840m/2gb 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n +...] => "nvidia 840m",
      %Q[15.6" led (1366x768), intel core i5-4210u 1.7ghz, 4gb ddr3, 1tb Жесткий диск, nvidia geforce 840m 2gb, dvd super multi, wi-fi 802.11b/g/n, bluetooth, 1xhdmi, 1...] => "nvidia 840m",
      %Q[15.6" led (1366x768) non-glare, intel core i5-4210u 1.7ghz, 4gb ddr3, 1tb Жесткий диск, nvidia geforce 840m 2gb, dvd super multi, wi-fi 802.11b/g/n, bluetooth,...] => "nvidia 840m",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), amd radeon hd r7 m265 2gb ddr3, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400r...] => "amd m265",
      %Q[15.6" led (1366x768) non-glare, intel core i5-4210u 1.7ghz, 4gb ddr3, 1tb Жесткий диск, nvidia geforce 820m 1gb, dvd super multi, wi-fi 802.11b/g/n, bluetooth,...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, t...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, t...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 1tb 5400rpm, tra...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 1tb 5400rpm, tra...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i5-4210u (up to 2.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 1tb 5400rpm, tra...] => "nvidia 820m",
      %Q[13.3" hd anti-glare, intel core i5-4210u 1.7ghz/3mb, 4gb ram, 500gb Жесткий диск, intel hd graphics, non-intel 1x1 b/g/n + bt, ethernet, 2in1 Кардридер, 4 ce...] => "intel hd",
      %Q[15.6" hd (1366x768) ag, intel core i5-4210u Процессор 2.7ghz/3mb, 4gb ddr3, 500gb 5400rpm, intel hd graphics, non-intel 1x1 b/g/n+bt4.0, dvd±rw, 4cell...] => "intel hd",
      %Q[15.6" hd (1366x768), intel core i5-4200u 1.60ghz, amd radeon r7 m265 2gb, 4gb, sata 1tb, dvd super multi dl, wlan 802.11 b/g/n, microsoft windows 8.1,...] => "amd m265",
      %Q[15.6" hd (1366x768), intel core i5-4200u 1.60ghz, amd radeon r7 m265 2gb, 8gb, sata 1tb 5400rpm, dvd super multi dl, wlan 802.11 b/g/n, microsoft wind...] => "amd m265",
      %Q[15.6" hd 1366x768 led anti-glare, intel core i5-4200u 1.6ghz/3mb, intel hd 4000, 4gb ddr3-1600, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + b...] => "intel 4000",
      %Q[17.3"(1600x900) led glare hd+, intel pentium 3550m 2.3ghz, 4gb ddr3-1600, nvidia geforce gt 720m 2gb, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, ca...] => "nvidia 720m",
      %Q[17.3" hd+ (1600x900), intel pentium 2020m, 2.4ghz, intel hd graphics, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, linpus linux, webcam, hd...] => "intel hd",
      %Q[15.6" led (1366x768) non-glare, intel core i3-4030u 1.90 mhz, 4gb, 500gb 5400rpm, nvidia geforce 840m 2gb, dvd super multi, wlan 802.11b/g/n +bluetoot...] => "nvidia 840m",
      %Q[15.6" wxga (1366x768) non-glare, intel core i3-4030u 1.9ghz, nvidia geforce 820m 1gb, 4gb, sata 500gb 5400rpm, wlan 802.11b/g/n, linux, 1xusb 3.0/2x u...] => "nvidia 820m",
      %Q[17.3" glare hd+ (1600x900) led glare, intel core i3-4030u (1.9ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm,...] => "nvidia 820m",
      %Q[15.6" led (1366x768) matte, intel core i3-4030u, 4gb ddr3, 500gb Жесткий диск, intel hd graphics 4400, Общий vram, dvd sm, bgn, bt, hdmi, 4 cell batt., hd cam...] => "intel 4400",
      %Q[15.6" wxga (1366x768) non-glare, intel core i3-4030u 1.9ghz, intel hd graphics 4400, 4gb, sata 500gb 5400rpm, wlan 802.11b/g/n, linux, 3xusb, sd card...] => "intel 4400",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4030u (1.9ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm hybrid Жесткий диск ,...] => "intel 4400",
      %Q[15.6" hd (1366x768)С антибликовым покрытием, intel core i3-4030u 1.90ghz, intel hd graphics 4400, 4gb, sata 500gb, dvd super multi, wlan 802.11 b/g/n, windows 8.1,...] => "intel 4400",
      %Q[17.3" glare hd+ (1600x900) led glare, intel core i3-4030u (1.9ghz/3mb), intel hd4400 graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray loa...] => "intel 4400",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4030u 1.9ghz/3mb, 4gb ddr3-1600, 500gb 5400rpm, integrated graphics, sm dvd+-rw, non-intel 1x1 b/g/n + bt...] => nil,
      %Q[15.6" hd 1366x768 led glare, intel core i3-4030u 1.9ghz/3mb, nv gt820m/2gb, 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + bluetoot...] => nil,
      %Q[13.3" hd anti-glare, intel core i3-4030u 1.9ghz/3mb, 4gb ram, 500gb Жесткий диск, intel hd graphics, non-intel 1x1 b/g/n + bt, ethernet, 2in1 Кардридер, 4 ce...] => "intel hd",
      %Q[15.6" hd 1366x768 led anti-glare, intel core i3-4010u 1.7ghz/3mb, intel hd 4400, 4gb ddr3-1600, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + b...] => "intel 4400",
      %Q[14.0" hd (1366x768)С антибликовым покрытием wled, intel core i3-4010u (1.7ghz/3mb), intel hd 4400, 4gb (1x4gb) ddr3l-1600mhz, 500gb 5400rpm sata Жесткий диск, Внутри / Нет...] => "intel 4400",
      %Q[15.6" hd 1366x768 led glare, intel core i3-4010u 1.7ghz/3mb, nvidia gt820m/2gb, 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + Синий...] => "nvidia gt820m",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4400",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4400",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4400",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4400",
      %Q[15.6" hd (1366x768) led glare, intel core i3-4005u (1.7ghz/3mb), intel hd graphics 4400, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4400",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, intel hd, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth...] => nil,
      %Q[15.6" led (1366x768) matte, intel i3-4005u, 4gb, 1tb, dvd, intel hd, blutooth, hdmi, usb 3.0, sd reader, cam, linux, iron, eng-rus kbd] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u (1.7 ghz), intel hd, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, b...] => nil,
      %Q[15.6" led (1366x768) non-glare, intel core i3-4005u, 4gb, 1tb, nvidia geforce 820 1gb, dvd, bluetooth, hdmi, usb 3.0, sd reader, cam, linux, Черный, en...] => "nvidia 820",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, intel hd, 4gb ddr3l (1600mhz), sata 1tb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, bluetooth 4.0...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, intel hd, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, bluetooth 4...] => nil,
      %Q[15.6" hd (1366x768) ag, intel core i3-4005u Процессор 1.7ghz/3mb, 4gb ddr3, 500gb 5400rpm, intel hd graphics, non-intel 1x1 b/g/n+bt4.0, dvd±rw, 4cell...] => "intel hd",
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => nil,
      %Q[15.6" fhd trubrite led (1920x1080), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1x...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => nil,
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), intel hd4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, wlan 802.11...] => "intel 4000",
      %Q[15.6" hd 1366x768 led, intel core i3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск/ bt4.0/ bgn/ 4 cell batt./ hd камера/ usb 3.0/ Черный/ linpus...] => "intel hd",
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), hd 4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, bluetooth, wlan...] => nil,
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), hd 4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, bluetooth, wlan...] => nil,
      %Q[15.6" hd 1366x768 led glare, intel core i3-3217u 1.8 ghz/3mb, geforce gt710 1gb, 4gb ddr3, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + blueto...] => "nvidia gt710",
      %Q[15.6" hd 1366x768 led glare, intel core i3-3217u 1.8ghz, nvidia geforce gt710 1gb, 4gb ddr3, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + Синий...] => "nvidia gt710",
      %Q[15.6" hd (1366x768) led glare, amd a6-6310 apu quad-core, amd radeon hd r5 m230 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, Беспроводной ...] => "amd m230",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), nvidia geforce 820m 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray lo...] => "nvidia 820m",
      %Q[17.3" glare hd+ (1600x900) led glare, pentium 3558u (1.7ghz/2mb), intel hd4000 graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd...] => "intel 4000",
      %Q[15.6" hd (1366x768) led glare, pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802.11b/g/...] => nil,
      %Q[15.6" hd (1366x768) led glare, pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802.11b/g/...] => nil,
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => nil,
      %Q[15.6" hd (1366x768) led glare, intel pentium 3558u (1.7ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => nil,
      %Q[15.6" led (1366x768) cinecrystal , intel pentium 3556u , 4gb ddr3, 1tb Жесткий диск, nvidia geforce 820m 1gb, dvd sm, 802.11b/g/n, bt, hdmi, li-ion 6-cell 5000...] => "nvidia 820m",
      %Q[17.3" hd+ (1600x900), intel pentium 3556u, 1.7ghz, nvidia geforce 820m 2gb, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, microsoft windows...] => "nvidia 820m",
      %Q[13.3" hd (1366x768) led tft, intel pentium 3556u (2m cache, 1.70ghz), 4gb, 500gb, intel hd, bluetooth 4.0, usb3.0, hdmi, linux, aluminium, iron, eng k...] => nil,
      %Q[15.6" hd led 1366x768 glare, intel pentium 2117u 1.8ghz, nvidia geforce gt 820m 1gb, 4gb ddr3 500gb Жесткий диск, bt4.0, bgn, 4 cell batt., hd камера, usb 3.0,...] => "nvidia 820m",
      %Q[15.6" hd trubrite led (1366x768), intel pentium n3530, intel hd, 4gb ddr3l (1333mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11bgn, bluetooth 4...] => nil,
      %Q[11.6" touch hd (1366x768) led glare (ips), intel pentium n3530 (up to 2.58ghz/2mb), intel hd graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm,...] => "intel hd",
      %Q[15.6" hd trubrite led (1366x768), intel pentium n3520 2.42ghz/2mb, intel gma, 4gb ddr3-1600mhz, sata 500gb 5400rpm, sm dl dvd+/-rw, wlan 802.11b/g/n,...] => nil,
      %Q[15.6" hd (1366x768) led glare, amd a4-6210 apu quad-core, amd radeon hd r5 m230 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, Беспроводной ...] => "amd m230",
      %Q[11.6" touch hd led (1366x768) glare, intel atom z3775 1.46ghz/2mb, 2gb, 500gb 5400rpm + 32gb emmc, intel hd / wlan 802.11 a/b/g/n, bluetooth, windows...] => nil,
      %Q[15.6" hd (1366x768) led glare, intel celeron 2957u (1.4ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm hybrid Жесткий диск , 32gb cache, tra...] => nil,
      %Q[15.6" hd (1366x768) led glare, intel celeron 2957u (1.4ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => nil,
      %Q[15.6" led 1366x768 wxgag non-glare, intel celeron n2830 2.16ghz, intel hd graphics, 2gb ddr3, 320gb Жесткий диск, bgn, 4-cell battery, webcamera, usb 2.0/usb 3...] => "intel hd",
      %Q[15.6" hd trubrite led (1366x768), intel celeron n2830, 4gb ddr3l (1333mhz)/ sata 500gb 5400rpm, sm dl dvd+/-rw, wlan 802.11b/g/n, bluetooth 4.0/ ml, /...] => nil,
      %Q[15.6" led (1366x768)wxgag/ intel celeron n2820 Двухъядерный/ intel hd graphics/ vram shared/ 2gb ddr3/ 320gb Жесткий диск/ bgn/ bt/ usb3.0/ sd reader/ 4 cell batt...] => "intel hd",
      %Q[15.6" led 1366x768 wxgag non-glare, intel celeron n2815 1.86ghz, intel hd graphics, 2gb ddr3, 320gb Жесткий диск, bgn, 4-cell battery, webcamera, usb 2.0/usb 3...] => "intel hd",
      %Q[15.6" (1366x768) hd glossy, amd e1-6010 1.35 ghz, 4gb ddr3, 500gb 5400rpm, integrated amd radeon r2 series, wlan 802.11b/g/n +bluetooth 4.0, dvd±rw, 1...] => nil,
      %Q[15.6" led 1366x768 wxgag, intel core 3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск, bgn, bt, 4 cell batt. hd камера, usb 3.0, Черный, microsof...] => "intel hd",
    }
    data.each do |laptop_desc, gpu|
      assert_equal(get_gpu(laptop_desc), gpu)
    end
  end

  def test_get_sorted_laptops
    laptops = [%Q[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...],
      %Q[15.6" hd (1366x768), intel core i5-4200m 2.50ghz, 6gb (2gb+4gbddriii1600), 1tb 5400rpm, amd radeon hd 8750m 2gb, sm dvd+-rw, dos, Беспроводной  802.11 b/g/...]]
    sorted_laptops = get_sorted_laptops(laptops)
    first_laptop = sorted_laptops[0]
    second_laptop = sorted_laptops[1]
    assert_kind_of(Hash, first_laptop)
    assert(first_laptop[:avg_index] < second_laptop[:avg_index])
    assert_equal(first_laptop[:cpu], 'intel 4200m')
    assert_equal(first_laptop[:gpu], 'amd 8750m')
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

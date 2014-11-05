# encoding: utf-8
require 'test_helper'

class TextParserTest < ActionView::TestCase
  include TextParser

  def test_get_cpu_from_text_single
    data = %Q[17.3" (1600x900) led glare hd+, intel core i5-4210m 2.6ghz, 4gb ddr3-1600, intel hd 4600, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, Камера, 1xusb...]
    assert_equal(get_cpu_from_text(data), "intel 4210m")
  end

  def test_get_cpu_from_text
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
      %Q[15.6" led 1366x768 wxgag, intel core 3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск, bgn, bt, 4 cell batt. hd камера, usb 3.0, Черный, microsof...] => 'intel 3-3217u',
    }
    data.each do |laptop_desc, cpu|
      assert_equal(cpu, get_cpu_from_text(laptop_desc), laptop_desc)
    end
    
    found_percentage = data.values.reject{|v| v.nil?}.length / data.values.length.to_f * 100
    assert_equal(100, found_percentage.to_i)
  end

  def test_get_gpu_no_gpu_from_text
    data = %Q[15.6" HD TruBrite LED (1366x768), Intel Celeron N2830, 4GB DDR3L (1333MHz)/ SATA 500GB 5400rpm, SM DL DVD+/-RW, WLAN 802.11b/g/n, Bluetooth 4.0/ ML, /...]
    assert_equal("intel n2830", get_cpu_from_text(data))
    assert_equal(nil, get_gpu_from_text(data))
  end

  def test_get_gpu_from_text
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
      %Q[15.6" hd (1366x768) antiglare, intel core i3-3110m 2.4ghz/3mb, hd graphics 4000, 1x4gb ddr3-1600, 500gb 5400rpm, dvd±rw dl, dos, 802.11b/g/n, bt, 2xus...] => "intel 4000",
      %Q[17.3" hd+ (1600x900) led glare, intel core i3-3110m 2.4ghz, nvidia geforce gt720 2gb, 4gb, 1tb 5400rpm, dvd super multi, webcam, wifi, sd/mmc, dos, 2....] => "nvidia 720",
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
      %Q[13.3" hd anti-glare, intel core i5-4210u 1.7ghz/3mb, 4gb ram, 500gb Жесткий диск, intel hd graphics, non-intel 1x1 b/g/n + bt, ethernet, 2in1 Кардридер, 4 ce...] => nil,
      %Q[15.6" hd (1366x768) ag, intel core i5-4210u Процессор 2.7ghz/3mb, 4gb ddr3, 500gb 5400rpm, intel hd graphics, non-intel 1x1 b/g/n+bt4.0, dvd±rw, 4cell...] => nil,
      %Q[15.6" hd (1366x768), intel core i5-4200u 1.60ghz, amd radeon r7 m265 2gb, 4gb, sata 1tb, dvd super multi dl, wlan 802.11 b/g/n, microsoft windows 8.1,...] => "amd m265",
      %Q[15.6" hd (1366x768), intel core i5-4200u 1.60ghz, amd radeon r7 m265 2gb, 8gb, sata 1tb 5400rpm, dvd super multi dl, wlan 802.11 b/g/n, microsoft wind...] => "amd m265",
      %Q[15.6" hd 1366x768 led anti-glare, intel core i5-4200u 1.6ghz/3mb, intel hd 4000, 4gb ddr3-1600, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + b...] => "intel 4000",
      %Q[17.3"(1600x900) led glare hd+, intel pentium 3550m 2.3ghz, 4gb ddr3-1600, nvidia geforce gt 720m 2gb, 1tb 5400rpm, sm dvd+-rw, dos, Беспроводной  b/g/n, ca...] => "nvidia 720m",
      %Q[17.3" hd+ (1600x900), intel pentium 2020m, 2.4ghz, intel hd graphics, 4gb, sata 500gb, dvd super multi dl, wlan 802.11 b/g/n, linpus linux, webcam, hd...] => nil,
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
      %Q[13.3" hd anti-glare, intel core i3-4030u 1.9ghz/3mb, 4gb ram, 500gb Жесткий диск, intel hd graphics, non-intel 1x1 b/g/n + bt, ethernet, 2in1 Кардридер, 4 ce...] => nil,
      %Q[15.6" hd 1366x768 led anti-glare, intel core i3-4010u 1.7ghz/3mb, intel hd 4400, 4gb ddr3-1600, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + b...] => "intel 4400",
      %Q[14.0" hd (1366x768)С антибликовым покрытием wled, intel core i3-4010u (1.7ghz/3mb), intel hd 4400, 4gb (1x4gb) ddr3l-1600mhz, 500gb 5400rpm sata Жесткий диск, Внутри / Нет...] => "intel 4400",
      %Q[15.6" hd 1366x768 led glare, intel core i3-4010u 1.7ghz/3mb, nvidia gt820m/2gb, 4gb ddr3-1600, 1tb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + Синий...] => "nvidia 820m",
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
      %Q[15.6" hd (1366x768) ag, intel core i3-4005u Процессор 1.7ghz/3mb, 4gb ddr3, 500gb 5400rpm, intel hd graphics, non-intel 1x1 b/g/n+bt4.0, dvd±rw, 4cell...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => nil,
      %Q[15.6" fhd trubrite led (1920x1080), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 500gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1x...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel core i3-4005u, 4gb ddr3l (1600mhz), sata 750gb 5400rpm, sm dl dvd+r/+rw, wlan 802.11abgn, bluetooth 4.0, /1xus...] => nil,
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), intel hd4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, wlan 802.11...] => "intel 4000",
      %Q[15.6" hd 1366x768 led, intel core i3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск/ bt4.0/ bgn/ 4 cell batt./ hd камера/ usb 3.0/ Черный/ linpus...] => nil,
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), hd 4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, bluetooth, wlan...] => nil,
      %Q[15.6" hd (1366x768) wled glare, intel core i3-3217u (1.8ghz/3mb), hd 4000, 4gb (1x4gb) ddr3-1600mhz, sata 500gb 5400rpm, 8x dvd+/-rw, bluetooth, wlan...] => nil,
      %Q[15.6" hd 1366x768 led glare, intel core i3-3217u 1.8 ghz/3mb, geforce gt710 1gb, 4gb ddr3, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + blueto...] => "nvidia 710",
      %Q[15.6" hd 1366x768 led glare, intel core i3-3217u 1.8ghz, nvidia geforce gt710 1gb, 4gb ddr3, 750gb 5400rpm, sm dl 8x dvd+/-rw, wlan 802.11b/g/n + Синий...] => "nvidia 710",
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
      %Q[11.6" touch hd (1366x768) led glare (ips), intel pentium n3530 (up to 2.58ghz/2mb), intel hd graphics, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm,...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel pentium n3520 2.42ghz/2mb, intel gma, 4gb ddr3-1600mhz, sata 500gb 5400rpm, sm dl dvd+/-rw, wlan 802.11b/g/n,...] => nil,
      %Q[15.6" hd (1366x768) led glare, amd a4-6210 apu quad-core, amd radeon hd r5 m230 2gb ddr3l, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, Беспроводной ...] => "amd m230",
      %Q[11.6" touch hd led (1366x768) glare, intel atom z3775 1.46ghz/2mb, 2gb, 500gb 5400rpm + 32gb emmc, intel hd / wlan 802.11 a/b/g/n, bluetooth, windows...] => nil,
      %Q[15.6" hd (1366x768) led glare, intel celeron 2957u (1.4ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm hybrid Жесткий диск , 32gb cache, tra...] => nil,
      %Q[15.6" hd (1366x768) led glare, intel celeron 2957u (1.4ghz/2mb), hd4000, 4gb (1x4gb) ddr3l-1600mhz, sata 500gb 5400rpm, tray load dvd drive, wlan 802....] => nil,
      %Q[15.6" led 1366x768 wxgag non-glare, intel celeron n2830 2.16ghz, intel hd graphics, 2gb ddr3, 320gb Жесткий диск, bgn, 4-cell battery, webcamera, usb 2.0/usb 3...] => nil,
      %Q[15.6" hd trubrite led (1366x768), intel celeron n2830, 4gb ddr3l (1333mhz)/ sata 500gb 5400rpm, sm dl dvd+/-rw, wlan 802.11b/g/n, bluetooth 4.0/ ml, /...] => nil,
      %Q[15.6" led (1366x768)wxgag/ intel celeron n2820 Двухъядерный/ intel hd graphics/ vram shared/ 2gb ddr3/ 320gb Жесткий диск/ bgn/ bt/ usb3.0/ sd reader/ 4 cell batt...] => nil,
      %Q[15.6" led 1366x768 wxgag non-glare, intel celeron n2815 1.86ghz, intel hd graphics, 2gb ddr3, 320gb Жесткий диск, bgn, 4-cell battery, webcamera, usb 2.0/usb 3...] => nil,
      %Q[15.6" (1366x768) hd glossy, amd e1-6010 1.35 ghz, 4gb ddr3, 500gb 5400rpm, integrated amd radeon r2 series, wlan 802.11b/g/n +bluetooth 4.0, dvd±rw, 1...] => nil,
      %Q[15.6" led 1366x768 wxgag, intel core 3-3217u 1.8ghz, intel hd graphics, 4gb ddr3, 500gb Жесткий диск, bgn, bt, 4 cell batt. hd камера, usb 3.0, Черный, microsof...] => nil,
    }
    data.each do |laptop_desc, gpu|
      assert_equal(gpu, get_gpu_from_text(laptop_desc), laptop_desc)
    end
    
    found_percentage = data.values.reject{|v| v.nil?}.length / data.values.length.to_f * 100
    assert_equal(61, found_percentage.to_i)
  end
  
  def test_get_gpu_from_text_1
    assert_equal( 'nvidia 710', get_gpu_from_text("GeForce GT710 1GB"))
  end
  
  def test_get_gpu_from_text_1
    assert_equal( 'nvidia 720m', get_gpu_from_text("GeForce GT720M"))
  end

  def test_get_gpu_from_text_2
    assert_equal('nvidia 720', get_gpu_from_text("intel hd 4600 nvidia 720"))
    assert_equal('nvidia 720', get_gpu_from_text("nvidia 720 intel hd 4600"))
  end

  def test_get_gpu_from_text_3
    assert_equal( 'nvidia 740m', get_gpu_from_text("NVIDIA® GeForce® GT 740M 2GB"))
  end

end

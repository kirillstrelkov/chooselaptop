# frozen_string_literal: true

module TextParser
  @@bad_data = { name: 'Not found', index: 101 }
  def get_matched_string_using_regexps(text, regexps)
    text = text.downcase
    text = text.delete('®')
    text = text.delete('™')
    text = text.gsub('(tm)', '')
    regexps.each do |regexp, prefix|
      found = text[regexp]
      next if found.nil?

      found.strip!

      found = "#{prefix} #{found}" unless found.include?(prefix)
      return found
    end
    nil
  end

  def get_cpu_from_text(text)
    ideal_intel_regexp = /i\d+[ -]{1}\w+ ?/
    common_celeron = /celeron ?(processor)? ?\w+/
    common_pentium = /pentium ?(processor)? ?\w+/
    common_intel = /intel ?(atom)? ?\w+/
    intel_special = /intel core [i\w-]+/
    ideal_amd_regexp = /amd ?[\w-]+/
    ideal_amd_regexp2 = /amd ?\w+ ?[\w-]+/
    amd_regexp = /amd ?(\w+-core)? ?[\w-]+/
    amd_regexp2 = /amd ?(ryzen)? ?\d+ ?[\d\w]*/
    amd_special = /amd ?[\w-]+/
    # NOTE: order is important!!!
    regexps = [
      [ideal_intel_regexp, 'intel'],
      [amd_regexp2, 'amd'],
      [ideal_amd_regexp, 'amd'],
      [ideal_amd_regexp2, 'amd'],
      [intel_special, 'intel'],
      [common_celeron, 'intel'],
      [common_pentium, 'intel'],
      [common_intel, 'intel'],
      [amd_regexp, 'amd'],
      [amd_special, 'amd']
    ]

    get_matched_string_using_regexps(text, regexps)
  end

  def get_gpu_from_text(text)
    ideal_intel_regexp = /intel ?(\w*)? ?\w* ?graphics ?\w*\d+\w*/
    intel_hd_regexp = /intel u?hd ?\w* ?(graphics)? ?\w*\d+\w*/
    intel_hd_regexp2 = /u?hd graphics ?\w*\d+\w*/
    ideal_amd_regexp = /amd ?\w* ?\w* \w*\d+\w*/
    amd_regexp2 = /amd ?\w* ?\w* ?\w* \w*\d+\w*/
    amd_regexp3 = /(radeon ?(vega)? ?\d+)/
    amd_regexp4 = /radeon ?(hd|r.?|pro|)? ?[\w-]*/
    ideal_nvidia_regexp = /(nvidia|geforce|quadro) ?(gtx?|rtx?)? ?\w*\d+\w* ?(super)? ?(ti)? ?(max-q)?/
    # NOTE: order is important!!!
    regexps = [
      [ideal_nvidia_regexp, 'nvidia'],
      [amd_regexp3, 'amd'],
      [amd_regexp4, 'amd'],
      [ideal_amd_regexp, 'amd'],
      [amd_regexp2, 'amd'],
      [ideal_intel_regexp, 'intel'],
      [intel_hd_regexp, 'intel'],
      [intel_hd_regexp2, 'intel']
    ]

    get_matched_string_using_regexps(text, regexps)
  end

  def get_cpu_or_gpu_data(cpu_or_gpu, sorted_names)
    unless cpu_or_gpu.nil?
      manufacturer = cpu_or_gpu.split[0]
      model = cpu_or_gpu.split[-1]
      sorted_names.each do |name, index|
        lowered_name = name.downcase
        if (manufacturer == lowered_name.split[0]) && lowered_name.split[-1].end_with?(model)
          return { name: name, index: index }
        end
      end
    end
    @@bad_data
  end

  def get_price_from_text(text)
    found = text.scan(/\d{2,}[.,]\d+{2}/)
    if found.empty?
      0.00
    else
      found[-1].to_f
    end
  end
end

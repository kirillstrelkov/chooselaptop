# encoding: utf-8
module TextParser
  @@bad_data = {:name => 'unknown', :index => -1}
  def get_matched_string_using_regexps(text, regexps)
    text = text.downcase
    text = text.delete("®", "™")
    text = text.gsub("(tm)", '')
    regexps.each do |regexp, prefix|
      found = text.scan(regexp)
      found.flatten!
      found.compact!
      return prefix + ' ' + found[-1] unless found.empty?
    end
    nil
  end

  def get_cpu_from_text(text)
    ideal_intel_regexp = /(i\d{1}-? ?(\d{4,}\w?))/
    common_celeron = /celeron ?(processor)? ?(\w?\d{3,4}\w?)/
    common_pentium = /pentium ?(processor)? ?(\w?\d{3,4}\w?)/
    common_intel = /intel ?(atom)? ?(\w?\d{3,4}\w?)/
    ideal_amd_regexp = /amd ?(\w\d-\d{3,4})/
    amd_regexp = /amd ?(\w+-core)? ?(\w\d-\d{3,4})/
    regexps = {
      ideal_intel_regexp => 'intel',
      ideal_amd_regexp => 'amd',
      common_celeron => 'intel',
      common_pentium => 'intel',
      common_intel => 'intel',
      amd_regexp => 'amd',
    }

    get_matched_string_using_regexps(text, regexps)
  end

  def get_gpu_from_text(text)
    ideal_intel_regexp = /intel ?([a-z]*)? ?[a-z]* ?graphics ?(\d{4,})?/
    intel_hd_regexp = /intel hd ?[a-z]* ?(graphics)? ?(\d{4,})?/
    ideal_amd_regexp = /amd ?[a-z]* ?[a-z0-9]* (\w?\d{3,}\w?)/
    ati_regexp = /ati ?[a-z]* ?[a-z0-9]* (\w?\d{3,}\w?)/
    ati_regexp_2 = /amd ?[a-z]* ?[a-z0-0]* ?[a-z0-9]* (\w?\d{3,}\w?)/
    ideal_nvidia_regexp = /nvidia ?[a-z]* ?[a-z]* ? (\w{0,2}\d{3,}\w?)/
    geforce_regexp = /geforce ?[a-z]* ? (\w{0,2}\d{3,}\w?)/
    regexps = {
      ideal_intel_regexp => 'intel',
      intel_hd_regexp => 'intel',
      ideal_amd_regexp => 'amd',
      ati_regexp => 'amd',
      ati_regexp_2 => 'amd',
      ideal_nvidia_regexp => 'nvidia',
      geforce_regexp => 'nvidia',
    }

    get_matched_string_using_regexps(text, regexps)
  end

  def get_cpu_or_gpu_data(cpu_or_gpu, sorted_names)
    unless cpu_or_gpu.nil?
      manufacturer = cpu_or_gpu.split[0]
      model = cpu_or_gpu.split[-1]
      sorted_names.each do |name, index|
        lowered_name = name.downcase
        if manufacturer == lowered_name.split[0] and lowered_name.split[-1].end_with?(model)
          return {:name => name, :index => index}
        end
      end
    end
    @@bad_data
  end

  def get_price_from_text(text)
    found = text.scan(/\d{2,}\.\d+{2}/)
    if found.empty?
      return 0.00
    else
      return found[-1].to_f
    end
  end
end
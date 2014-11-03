module QueryHelper
  def get_query(hash)
    if !hash.nil? &&  hash.is_a?(String)
      Query.where(:hash_string => hash).first
    end
  end

  def post_query(query, delimiter)
    if !query.nil? && !delimiter.nil? && query.is_a?(String) && delimiter.is_a?(String)
      md5 = Digest::MD5.new
      md5.update(query)
      md5.update(delimiter)

      hash = md5.hexdigest
      result = get_query(hash)
      if result.nil?
        Query.create(:query_string => query, :delimiter => delimiter, :hash_string => hash)
      else
        result
      end
    end
  end
end

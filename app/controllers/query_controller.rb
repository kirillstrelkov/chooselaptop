class QueryController < ApplicationController
  include QueryHelper

  def get
    hash = params[:hash]
    result = get_query(hash)
    respond_to do |format|
      format.json {render :json => result}
    end
  end

  def create
    result = 'null'
    query = params[:query]
    delimiter = params[:delimiter]
    result = post_query(query, delimiter) if !query.nil? && !delimiter.nil?
    respond_to do |format|
      format.json {render :json => result.to_json(:only => [:hash_string])}
    end
  end
end

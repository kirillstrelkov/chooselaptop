# frozen_string_literal: true

class QueryController < ApplicationController
  include QueryHelper

  def get
    hash = query_params[:hash]
    result = get_query(hash)
    respond_to do |format|
      format.json { render json: result }
    end
  end

  def create
    result = 'null'
    query = query_params[:query]
    delimiter = query_params[:delimiter]
    result = post_query(query, delimiter) if !query.nil? && !delimiter.nil?
    respond_to do |format|
      format.json { render json: result.to_json(only: [:hash_string]) }
    end
  end

  private

  def query_params
    params.permit(:query, :delimiter, :hash_string, :hash, :query_string)
  end
end

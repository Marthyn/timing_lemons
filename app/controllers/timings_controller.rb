# frozen_string_literal: true

require 'net/http'
require 'dalli'

class TimingsController < ApplicationController
  def show
    if ENV['MEMCACHIER_SERVERS'] && cache && cached_result = cache.get('result')
      render json: cached_result
    else
      result = Net::HTTP.get(URI("#{ENV['FEED_URL']}?_=#{params[:id]}"))
      load_cache(result)
      render json: result
    end
  end

  private

  def load_cache(result)
    cache.set('result', result, ttl = 4.seconds)
  rescue StandardError
    nil
  end

  def cache
    Dalli::Client.new((ENV['MEMCACHIER_SERVERS'] || '').split(','),
                      username: ENV['MEMCACHIER_USERNAME'],
                      password: ENV['MEMCACHIER_PASSWORD'],
                      failover: true, # default is true
                      socket_timeout: 1.5, # default is 0.5
                      socket_failure_delay: 0.2, # default is 0.01
                      down_retry_delay: 60) # default is 60
  rescue StandardError
    nil
  end
end

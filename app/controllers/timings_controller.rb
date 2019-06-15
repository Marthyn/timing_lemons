require 'net/http'

class TimingsController < ApplicationController
  def show
    result = Net::HTTP.get(URI("#{ENV['FEED_URL']}?_=#{params[:id]}"))
    render json: result
  end
end

class WaitlistRequestsController < ApplicationController
  require 'net/http'
  require 'json'

  def index

    url = URI.parse('http://127.0.0.1:4000/registration_requests.json')
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) do |http|
      http.request(request)
    end
    @requests = JSON.parse(response.body)
  end

  def show
    index = params[:id]
    url = URI.parse("http://127.0.0.1:4000/registration_requests/#{index}.json")

    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) do |http|
      http.request(request)
    end
    @request = JSON.parse(response.body)
  end
end

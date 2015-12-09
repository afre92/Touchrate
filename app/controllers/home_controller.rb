class HomeController < ApplicationController
before_action :require_user, only: [:index, :show]
    # def overallData(tiempo, kind)
    #   require 'json'
    #   require 'net/http'
    #   url = 'http://reports.touchrate.com/o/analytics/dashboard?api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"]
    #   resp = Net::HTTP.get_response(URI.parse(url))
    #   dashboard = JSON.parse(resp.body)
    #   puts dashboard[tiempo]["dashboard"][kind]["total"]
    # end
    #
    #   def maxStore
    #   nueva = []
    #   require 'json'
    #   require 'net/http'
    #   url = 'http://reports.touchrate.com/o?method=user_details&api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"]
    #   resp = Net::HTTP.get_response(URI.parse(url))
    #   results = JSON.parse(resp.body)
    #     results["aaData"].each do |n|
    #     nueva.push(n["sc"])
    #     end
    #   puts nueva
    #   end

end

module ApplicationHelper
    require "net/https"
    require "uri"
    require "json"
    require "date"
    require 'jsonpath'

   def topCatandSub
     uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"]+'&event=Categories&segmentation=title&period=30days')
     http = Net::HTTP.new(uri.host, uri.port)
     http.use_ssl = true
     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
     request = Net::HTTP::Get.new(uri.request_uri)
     resp = http.request(request)
     results = JSON.parse(resp.body)
     data = results["2015"]
     title = results["meta"]["title"]
     algo = data.slice(*title)
     algo2 = algo.sort_by { |k,v| v["c"] }
     algo2[-1][0].gsub("\\n"," ").gsub("Games"," ")

   end


   def overallData(tiempo, kind)
      uri = URI.parse('https://touch-rate.com/o/analytics/dashboard?api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(request)
      results = JSON.parse(resp.body)
      results[tiempo]["dashboard"][kind]["total"]
   end


     def maxStore(arg1)
       storeName = nil
       arr = []
       uri = URI.parse('https://touch-rate.com/o?method=user_details&api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"])
       http = Net::HTTP.new(uri.host, uri.port)
       http.use_ssl = true
       http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       request = Net::HTTP::Get.new(uri.request_uri)
       resp = http.request(request)
       results = JSON.parse(resp.body)
         results["aaData"].each do |n|
            arr.push(n["sc"])
          end
           arr.max
            if arg1 == "storeName"
               results["aaData"].each do |u|
                 if u["sc"] == arr.max
                    return storeName = u["name"]
                 end
               end
           end
      end

    def dayMaxEng
      d = nil
      arr = []
      uri = URI.parse('https://touch-rate.com/o/analytics/sessions?api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"]+'&period=30days')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(request)
      results = JSON.parse(resp.body)
         results.each do |n|
         arr.push(n["t"])
         end
       arr.max
         results.each do |n|
           if n["t"] == arr.max
             maxDate = n["_id"]
             d = Date.parse(maxDate)
             return d.strftime('%A')
          end
        end

     end

      def categories(int)
         vow = nil
         arr = []
         uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"]+'&event=Categories&segmentation=title&period=30days')
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         request = Net::HTTP::Get.new(uri.request_uri)
         resp = http.request(request)
         results = JSON.parse(resp.body)
         data = results["2015"]
         title = results["meta"]["title"]
         algo = data.slice(*title).to_a
           if algo[int] == nil
             return "No Data"
           else
             return  vow = algo[int][0].gsub("\\nGames"," ").gsub("Games\\n"," ")
           end
      end

        def percentCategories(int)
         arr = []
         uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+ENV["API_KEY"]+'&app_id='+ENV["APP_ID"]+'&event=Categories&segmentation=title&period=30days')
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         request = Net::HTTP::Get.new(uri.request_uri)
         resp = http.request(request)
         results = JSON.parse(resp.body)
         data = results["2015"]
         title = results["meta"]["title"]
         algo = data.slice(*title).to_a
           if algo[int] == nil
                return 0
             else
               algo[int][0].gsub("\\n"," ")
                 algo.each do |a|
                 arr.push(a[1]["c"])
                end
              return algo[int][1]["c"]*100 / arr.sum
            end
        end




end

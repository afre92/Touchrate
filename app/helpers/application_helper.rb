module ApplicationHelper
    require "net/https"
    require "uri"
    require "json"
    require "date"
    require 'jsonpath'
    require 'digest/sha1'


    def milToDateAndTime(mil)
      d = Time.strptime(mil.to_s, '%Q')
      d.strftime("%m-%d-%Y %H:%M:%S")
    end


  def milToDate(mil)
    d = Time.strptime(mil.to_s, '%Q')
    d.strftime("%m-%d-%Y")
  end

  def reportsCat(api_key, app_id, app_key)
    var = nil
    id = nil
    name = nil
    events = nil
    arr = []
    uri = URI.parse('https://touch-rate.com/o?method=user_details&api_key='+api_key+'&app_id='+app_id)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(request)
    results = JSON.parse(resp.body)
    results["aaData"].each do |n|
      id = n["_id"]
      name = n["name"][6, 15]
      uid = Digest::SHA1.hexdigest app_key+name
      uri1 = URI.parse('https://touch-rate.com/o?method=user_details&uid='+uid+'&api_key='+api_key+'&app_id='+app_id)
      https = Net::HTTP.new(uri1.host, uri1.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request1 = Net::HTTP::Get.new(uri1.request_uri)
      resp1 = https.request(request1)
      events = JSON.parse(resp1.body)["events"].each do |c|
      if c["ts"] >= getDateRange('from').to_i && c["ts"] < getDateRange('to').to_i
        if c["key"] == "Categories"
          c.merge!("name" => name)
          arr.push(c)
        end

        end
      end
    end
    return arr
  end

  def reportsEng(api_key, app_id, app_key)
    var = nil
    id = nil
    name = nil
    sessions = nil
    city = nil
    arr = []
    arr2 =[]
    uri = URI.parse('https://touch-rate.com/o?method=user_details&api_key='+api_key+'&app_id='+app_id)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(request)
    results = JSON.parse(resp.body)
    results["aaData"].each do |n|
      id = n["_id"]
      city = n["cty"]
      name = n["name"][6, 15]
      uid = Digest::SHA1.hexdigest app_key+name
      uri1 = URI.parse('https://touch-rate.com/o?method=user_details&uid='+uid+'&api_key='+api_key+'&app_id='+app_id)
      https = Net::HTTP.new(uri1.host, uri1.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request1 = Net::HTTP::Get.new(uri1.request_uri)
      resp1 = https.request(request1)
      sessions = JSON.parse(resp1.body)["sessions"].each do |c|
        if c["ts"] >= getDateRange('from').to_i && c["ts"] < getDateRange('to').to_i
          c.merge!("name" => name)
          c.merge!("city" => city)
          arr.push(c)
        else
          arr.delete(c)
        end
      end
    end
    return arr
  end

  def reports(api_key, app_id, app_key)
    var = nil
    id = nil
    name = nil
    events = nil
    arr = []
    uri = URI.parse('https://touch-rate.com/o?method=user_details&api_key='+api_key+'&app_id='+app_id)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(request)
    results = JSON.parse(resp.body)
    results["aaData"].each do |n|
      id = n["_id"]
      city = n["cty"]
      name = n["name"][6, 15]
      uid = Digest::SHA1.hexdigest app_key+name
      uri1 = URI.parse('https://touch-rate.com/o?method=user_details&uid='+uid+'&api_key='+api_key+'&app_id='+app_id)
      https = Net::HTTP.new(uri1.host, uri1.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request1 = Net::HTTP::Get.new(uri1.request_uri)
      resp1 = https.request(request1)
      sessions = JSON.parse(resp1.body)["events"].each do |c|
      if c["ts"] >= getDateRange('from').to_i && c["ts"] < getDateRange('to').to_i
        if c["key"] == "Contact Info"
        c.merge!("name" => name)
        c.merge!("city" => city)
        arr.push(c)
      end
      end
      end
    end
    return arr
  end


  def sslVal(link)
    uri = URI.parse(link)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(request)
    results = JSON.parse(resp.body)
  end

  def numofStores(api_key, app_id)
    sslVal('https://touch-rate.com/o?method=user_details&api_key='+api_key+'&app_id='+app_id+'&period=['+getDateRange('from')+','+getDateRange('to')+']')["aaData"].length
  end

   def sessionsTime(api_key, app_id)
     t = 0
     s = 0
     uri = URI.parse('https://touch-rate.com/o/analytics/sessions?api_key='+api_key+'&app_id='+app_id+'&period=['+getDateRange('from')+','+getDateRange('to')+']')
     http = Net::HTTP.new(uri.host, uri.port)
     http.use_ssl = true
     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
     request = Net::HTTP::Get.new(uri.request_uri)
     resp = http.request(request)
     results = JSON.parse(resp.body)
     results.each do |n|
       t += n["d"]
       s += n["t"]
     end
     subtotal =  t/s
     total = subtotal/60.to_f
     return total.round(2)
   end


   def getDateRange(arg)
     url = request.original_url
     uri = URI.parse(url)
     params = CGI.parse(uri.query)
     if arg == "from"
       fromm = params['from'].first
       return fromm
     else
       to = params['to'].first
       return to
     end
   end

   def totalSessions(api_key, app_id)
     t = 0
     uri = URI.parse('https://touch-rate.com/o/analytics/sessions?api_key='+api_key+'&app_id='+app_id+'&period=['+getDateRange('from')+','+getDateRange('to')+']')
     http = Net::HTTP.new(uri.host, uri.port)
     http.use_ssl = true
     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
     request = Net::HTTP::Get.new(uri.request_uri)
     resp = http.request(request)
     results = JSON.parse(resp.body)
     results.each do |n|
       t += n["t"]
     end
     return t
   end



   def overallData(tiempo, kind, api_key, app_id)
      uri = URI.parse('https://touch-rate.com/o/analytics/dashboard?api_key='+api_key+'&app_id='+app_id)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(request)
      results = JSON.parse(resp.body)
      results[tiempo]["dashboard"][kind]["total"]
   end


     def maxStore(arg1, api_key, app_id)
       storeName = nil
       arr = []
       uri = URI.parse('https://touch-rate.com/o?method=user_details&api_key='+api_key+'&app_id='+app_id)
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

    def dayMaxEng(api_key, app_id)
      d = nil
      arr = []
      uri = URI.parse('https://touch-rate.com/o/analytics/sessions?api_key='+api_key+'&app_id='+app_id+'&period=['+getDateRange("from")+','+getDateRange("to")+']')
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
             return d.strftime('%A %b %d')
          end
        end

     end

     def getEvents(event, segmentation, api_key, app_id)
       uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+api_key+'&app_id='+app_id+'&event='+event+'&segmentation='+segmentation+'&period=30days')
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

      def categories(int, api_key, app_id)
         vow = nil
         arr = []
         uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+api_key+'&app_id='+app_id+'&event=Categories&segmentation=title&period=30days')
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         request = Net::HTTP::Get.new(uri.request_uri)
         resp = http.request(request)
         results = JSON.parse(resp.body)
         data = results["2015"]
         title = results["meta"]["title"]
         algo = data.slice(*title).to_a
         algo2 = algo.sort_by { |k,v| v["c"] }
           if algo2[int] == nil
             return "No Data"
           else
               vow = algo2[int][0].gsub("\\nGames"," ").gsub("Games\\n"," ")[0,24]
           end
      end
      def subCategories(int, api_key, app_id)
         vow = nil
         arr = []
         uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+api_key+'&app_id='+app_id+'&event=Subcategories&segmentation=title&period=30days')
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         request = Net::HTTP::Get.new(uri.request_uri)
         resp = http.request(request)
         results = JSON.parse(resp.body)
         data = results["2015"]
         title = results["meta"]["title"]
         algo = data.slice(*title).to_a
         algo2 = algo.sort_by { |k,v| v["c"] }
           if algo2[int] == nil
             return "No Data"
           else
             return  vow = algo2[int][0].gsub("\\nGames"," ").gsub("Games\\n"," ").gsub("Games", "")[0,24]
           end
      end

      def products(int, api_key, app_id)
         vow = nil
         arr = []
         uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+api_key+'&app_id='+app_id+'&event=Products&segmentation=title&period=30days')
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         request = Net::HTTP::Get.new(uri.request_uri)
         resp = http.request(request)
         results = JSON.parse(resp.body)
         data = results["2015"]
         title = results["meta"]["title"]
         algo = data.slice(*title).to_a
         algo2 = algo.sort_by { |k,v| v["c"] }
           if algo2[int] == nil
             return "No Data"
           else
             return  vow = algo2[int][0].gsub("\\nGames"," ").gsub("Games\\n"," ").gsub("Game","")[0,24]
           end
      end

        def percentCategories(int)
         arr = []
         uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+user.api_key+'&app_id='+user.app_id+'&event=Categories&segmentation=title&period=30days')
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

        def popularDay(api_key, app_id)
          week = [0, 0, 0, 0, 0, 0, 0]
          d = nil
          uri = URI.parse('https://touch-rate.com/o/analytics/sessions?api_key='+api_key+'&app_id='+app_id+'&period=30days')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri.request_uri)
          resp = http.request(request)
          results = JSON.parse(resp.body)
          results.each do |n|
            maxDate = n["_id"]
            d = Date.parse(maxDate)
              if d.strftime('%A') == "Monday"
                week[0] += n["t"]
              elsif d.strftime('%A') == "Tuesday"
                week[1] += n["t"]
              elsif d.strftime('%A') == "Wednesday"
                week[2] += n["t"]
              elsif d.strftime('%A') == "Thursday"
                week[3] += n["t"]
              elsif d.strftime('%A') == "Friday"
                week[4] += n["t"]
              elsif d.strftime('%A') == "Saturday"
                week[5] += n["t"]
              else
                week[6] += n["t"]
              end
            end
          maxIndex = week.index(week.max)
          if maxIndex == 0
            return "Monday"
          elsif maxIndex == 1
            return "Tuesday"
          elsif maxIndex == 2
            return "Wednesday"
          elsif maxIndex == 3
            return "Thursday"
          elsif maxIndex == 4
            return "Friday"
          elsif maxIndex == 5
            return "Saturday"
          elsif maxIndex == 6
            return "Sunday"
          end
        end



        def communication(meta, api_key, app_id)
          uri = URI.parse('https://touch-rate.com/o?method=events&api_key='+api_key+'&app_id='+app_id+'&event=Contact Info&period=30days')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri.request_uri)
          resp = http.request(request)
          results = JSON.parse(resp.body)
          data = results["2016"]
          title = results["meta"][meta].length
        end


        def timePeriod(api_key, app_id)
          uri = URI.parse('https://touch-rate.com/o/analytics/dashboard?api_key='+api_key+'&app_id='+app_id)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri.request_uri)
          resp = http.request(request)
          results = JSON.parse(resp.body)
          results["30days"]["period"]
        end

end
# if c["ts"] >= 1454497202900 && c["ts"] < 1455102002900
#   arr.push(c["ts"])
# else
#
# end

# if a["ts"] >= getDateRange('from').to_i && a["ts"] < getDateRange('to').to_i
#   arr.push(a)
# else
#   arr.delete(a)
# end

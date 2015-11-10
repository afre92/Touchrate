$(document).ready(function(){
 var sessionsArr = new Array();
    // $.ajax({
    //   url: "http://reports.touchrate.com/o/analytics/dashboard?
    //   dataType: 'jsonp',
    //   success: function(results){
    //     passValues(results);
    //     }
    //
    //
    // });
    $.ajax({
        url: 'https://touch-rate.com/o/analytics/sessions?api_k'
        dataType: 'jsonp',
        success: function(results){
            drawChart(results);
            console.log(results)
          }
      });

    $.ajax({
        url: "http://reports.touchrate.com/o?method=user_details"
        dataType: 'jsonp',
        success: function(results){
          console.log(results)
            var l = results["aaData"].length    /////////////////////////// SUPER WET CODE THAT I HAVE TO FIX///////////////////
            var arr = results["aaData"]         // iterates through results to get sc(sessions count)of every store
            for( var i = 0 ; i < l ; i++ ) {
              var sc = arr[i].sc
              sessionsArr.push(sc)
            };
            var largest = Math.max.apply(Math, sessionsArr);   // calculte the max of sc
            for(var j = 0 ; j < l ; j++ ){                     // finds a store with the max sc and resturns it... What if i get two stores?
              if (arr[j].sc === largest ) {
                var storeMaxSessions = arr[j].name
              }
            };
           maxValues(storeMaxSessions, largest);
          }
      });



    function maxValues(maxstore, maxsessions){
      $(".maxStore").append(maxstore)
      $(".maxSessions").append(maxsessions)
    };



    function passValues(value){
        $(".numberOfStores").append(value["7days"]["dashboard"]["total_users"]["total"]),
        $(".numberOfEngagements").append(value["7days"]["dashboard"]["total_sessions"]["total"])

      };

    function drawChart(results) {
          new Morris.Line({
              element: 'week',
              data: results,
              xkey: '_id',
              ykeys: ['t'],
              labels: ['Engagements'],
              lineColors: ['#009933'],
              smooth: false

        })
    };
});

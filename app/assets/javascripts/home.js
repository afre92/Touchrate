


  $.ajax({
    url: "http://reports.touchrate.com/o/analytics/sessions?api_key="+ENV[API_KEY]+"&app_id="+ENV[API_ID],
    dataType: 'jsonp',
    success: function(results){


      var numEngGraph = new Array();
      var weekWithYear = new Array();
      var weekNoYear = new Array();

      $.each(results, function() {
        if (this.value == "2015"){
          this.slice(5, 15);
        }
      });
        drawChart(results);
      }
  });


    function drawChart(results) {

    new Morris.Line({
        element: 'week',
        data: results,
        xkey: '_id',
        ykeys: ['t'],
        labels: ['Engagements'],
        lineColors: ['#009933']

      })
    };

$(document).ready(function(){
 var sessionsArr = new Array();


      function drawChart(results) {
          new Morris.Line({
              element: 'month',
              data: results,
              xkey: '_id',
              ykeys: ['t'],
              labels: ['Engagements'],
              lineColors: ['#61B3FA'],
              smooth: false

        })
    };

    $.ajax({
        url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period=30days',
        dataType: 'jsonp',
        success: function(results){
            drawChart(results);
          }
      });



});

$(document).ready(function(){

 var time = '30days';
 var sessionsArr = new Array();


      function drawChart(results) {
          new Morris.Line({
              element: 'month',
              data: results,
              xkey: '_id',
              ykeys: ['t'],
              labels: ['Engagements'],
              lineColors: ['#61B3FA'],
              smooth: false,
              resize: true

        })
    };

    $.ajax({
        url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period='+time,
        dataType: 'jsonp',
        success: function(results){
            drawChart(results);
          }
      });

      $('.7days').click(function(){
          $('#month').html("")
          $.ajax({
              url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period=7days',
              dataType: 'jsonp',
              success: function(results){
                  drawChart(results);
                }
            });

      });

});

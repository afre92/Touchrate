$(document).ready(function(){


validate();
   $('#from, #to').change(validate);




  $(function() {
    $( "#from" ).datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      maxDate: -2,
      onClose: function( selectedDate ) {
        var hry = $( "#to" ).datepicker( "option", "minDate", selectedDate );
        // console.log(hry)
      }
    });
    $( "#to" ).datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      maxDate: 0,
      onClose: function( selectedDate ) {
        var yu = $( "#from" ).datepicker( "option", "maxDate", selectedDate );
        // console.log(yu)
      }
    });
  });



 var sessionsArr = new Array();


  function drawChart(results) {
      new Morris.Line({
          element: 'month',
          data: results,
          xkey: '_id',
          ykeys: ['t'],
          labels: ['Engagements'],
          lineColors: ['#1a1a1a'],
          smooth: false,
          resize: true,
          // pointFillColors: ['#ff8433']

        })
    };

  function numberOfStores(results, time) {
    $(".results2").append(results[time]["dashboard"]["total_sessions"]["total"])

  };

  function maxStore(results){
    var l = results["aaData"].length
    var arr = results["aaData"]
      for( var i = 0 ; i < l ; i++ ) {
      var sc = arr[i].sc
      sessionsArr.push(sc)
      var largest = Math.max.apply(Math, sessionsArr);
           for(var j = 0 ; j < l ; j++ ){
              if (arr[j].sc === largest ) {
              var storeMaxSessions = arr[j].name
            }
        }
   $(".results3").append(storeMaxSessions)
   }
 };

  function popularDay(results){
    var d = null
    arr = [0,0,0,0,0,0,0]
    var l = results.length
    for (var i = 0 ; i < l ; i++){
      var c = results[i]["_id"].replace( /-/g, ',' );
      var h = new Date(c).toString()
      u = h.slice(0,3)
      if (u === "Mon"){
        arr[0] += results[i]["t"]
      }
      else if (u === "Tue"){
        arr[1] += results[i]["t"]
      }
      else if (u === "Wed"){
        arr[2] += results[i]["t"]
      }
      else if (u === "Thu"){
        arr[3] += results[i]["t"]
      }
      else if (u === "Fri"){
        arr[4] += results[i]["t"]
      }
      else if (u === "Sat"){
        arr[5] += results[i]["t"]
      }
      else if (u === "Sun"){
        arr[6] += results[i]["t"]
      }
    }



  var maxIndex = arr.indexOf(Math.max(...arr))

      if (maxIndex === 0) {
        $(".results4").append("Monday")
      }
      else if (maxIndex === 1){
        $(".results4").append("Tuesday")
      }
      else if (maxIndex === 2){
        $(".results4").append("Wednesday")
      }
      else if (maxIndex === 3){
        $(".results4").append("Thursday")
      }
      else if (maxIndex === 4){
        $(".results4").append("Friday")
      }
      else if (maxIndex === 5){
        $(".results4").append("Saturday")
      }
      else if (maxIndex === 6){
        $(".results4").append("Sunday")
      }
  }

  function period(data, period){
    $(".time-period").append(data[period]["period"])
  }


  function averageTime(data){
      $(".results5").append(data["7days"]["dashboard"]["avg_time"]["total"])
  }

  function newDate(data, arg){
    var a = data[0]["_id"]
    var b = data[data.length - 1]["_id"]
    var t = "/"
    var a1 = a.slice(0,4)
    var a3 = a.substring(5,10)
    var b1 = b.slice(0,4)
    var b3 = b.substring(5,10)
    var jsto =  b3.concat(t).concat(b1).replace("-","/")
    var jsfrom = a3.concat(t).concat(a1).replace("-","/")
    if( arg === "from") {
      $(".jsfrom").append(jsfrom)
    }
    else {
      $(".jsto").append(jsto)
    }


  }
  function allCategories(obj, int, pos){
    var keys = obj["meta"]["title"];
    var newObj = [];
    for (var i = 0; i < keys.length; i++) {
      if (obj["2015"][keys[i]] === undefined){
        newObj.push({
          name: keys[i],
          content: 0
          });
      }
      else {
        newObj.push({
          name: keys[i],
          content: obj["2015"][keys[i]]
      });
    }
  }
    newObj.sort(function(a, b) {
      if (a.content.c < b.content.c) return -1;
      if (a.content.c > b.content.c) return 1;
      return 0;
    });
      $(".results7-"+pos).append(newObj[newObj.length - int]["name"].replace("Games\\n", " ").replace("\\nGames"," ").replace("Games", "").slice(0,24))
  }


  function allSubcategories(obj, int, pos){
    var keys = obj["meta"]["title"];
    var newObj = [];
    for (var i = 0; i < keys.length; i++){
      if (obj["2015"][keys[i]] === undefined){
        newObj.push({
          name: keys[i],
          content: 0
          });
      }
      else {
        newObj.push({
          name: keys[i],
          content: obj["2015"][keys[i]]
      });
    }
  }
    // console.log(newObj)
    newObj.sort(function(a, b){
      if (a.content.c < b.content.c) return -1;
      if (a.content.c > b.content.c) return 1;
      return 0
    })

      $(".results8-"+pos).append(newObj[newObj.length - int]["name"].replace("Games\\n", " ").replace("\\nGames"," ").replace("Games", "").slice(0,24))

  }

    function sessionsNumber(data){
      var t = 0
      var l = data.length
      for (var i = 0; i < l; i++) {
        t += data[i]["t"]
    }
    $(".results2").append(t)
  }

    function numStore(data) {
      num = data["aaData"].length
      $('.results1').append(num)
    }



  function allProducts(obj, int, pos){
    var keys = obj["meta"]["title"];
    var newObj = [];
    for (var i = 0; i < keys.length; i++) {
      if (obj["2015"][keys[i]] === undefined){
        newObj.push({
          name: keys[i],
          content: 0
          });
      }
      else {
        newObj.push({
          name: keys[i],
          content: obj["2015"][keys[i]]
      });
    }
  }
    newObj.sort(function(a, b) {
      if (a.content.c < b.content.c) return -1;
      if (a.content.c > b.content.c) return 1;
      return 0;
    });

      $(".results9-"+pos).append(newObj[newObj.length - int]["name"].replace("Games", "").slice(0,24))
  }

    $.ajax({
        url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period=['+serfrom+','+serto+']',
        dataType: 'jsonp',
        success: function(results){
            drawChart(results)

          }
      });

      $('.7days').click(function(){
          $('#month').html("")
          $('.results1').html("")
          $('.results2').html("")
          $('.results3').html("")
          $('.results4').html("")
          $('.results5').html("")
          $('.results7-1').html("")
          $('.results7-2').html("")
          $('.results7-3').html("")
          $('.results8-1').html("")
          $('.results8-2').html("")
          $('.results8-3').html("")
          $('.results9-1').html("")
          $('.results9-2').html("")
          $('.results9-3').html("")
          $('.time-period').html("")
          $('.jsfrom').html("")
          $('.jsto').html("")
          document.getElementById('to').value='';
          document.getElementById('from').value='';
          $.ajax({
            url: 'https://touch-rate.com/o?method=user_details&api_key='+key+'&app_id='+id+'&period=7days',
            dataType: 'jsonp',
            success: function(results){
              numStore(results)
            }
          });


          $.ajax({
              url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period=7days',
              dataType: 'jsonp',
              success: function(results){
                  drawChart(results)
                  popularDay(results)
                  newDate(results, "from")
                  newDate(results, "to")


                }
          });

          $.ajax({
              url: 'https://touch-rate.com/o/analytics/dashboard?api_key='+key+'&app_id='+id+'&period=7days',
              dataType: 'jsonp',
              success: function(data){
                  numberOfStores(data, "7days")
                  averageTime(data)
               }
          });
          $.ajax({
            url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Subcategories&segmentation=title&period=7days',
            dataType: 'jsonp',
            success: function(data){
              allSubcategories(data, 1, 1)
              allSubcategories(data, 2, 2)
              allSubcategories(data, 3, 3)
            }
          });
          $.ajax({
            url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Categories&segmentation=title&period=7days',
            dataType: 'jsonp',
            success: function(data4){
              allCategories(data4, 1, 1),
              allCategories(data4, 2, 2),
              allCategories(data4, 3, 3)
            }
          });




            $.ajax({
              url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Products&segmentation=title&period=7days',
              dataType: 'jsonp',
              success: function(data6){
                allProducts(data6, 1, 1)
                allProducts(data6, 2, 2)
                allProducts(data6, 3, 3)
              }
            });



          $.ajax({
              url: 'https://touch-rate.com/o?method=user_details&api_key='+key+'&app_id='+id+'&period=7days',
              dataType: 'jsonp',
              success: function(data3){
                  maxStore(data3)
              }
          });

          $.ajax({
            url: 'https://touch-rate.com/o/analytics/dashboard?api_key='+key+'&app_id='+id,
            dataType: 'jsonp',
            success: function(data){
              period(data, "7days")
            }
          });


      });

      $('.30days').click(function(){
          $('#month').html("")
          $('.results1').html("")
          $('.results2').html("")
          $('.results3').html("")
          $('.results4').html("")
          $('.results5').html("")
          $('.results7-1').html("")
          $('.results7-2').html("")
          $('.results7-3').html("")
          $('.results8-1').html("")
          $('.results8-2').html("")
          $('.results8-3').html("")
          $('.results9-1').html("")
          $('.results9-2').html("")
          $('.results9-3').html("")
          $('.time-period').html("")
          $('.jsfrom').html("")
          $('.jsto').html("")
          document.getElementById('to').value=''
          document.getElementById('from').value=''
          $.ajax({
            url: 'https://touch-rate.com/o?method=user_details&api_key='+key+'&app_id='+id+'&period=30days',
            dataType: 'jsonp',
            success: function(results){
              numStore(results)
            }
          });
          $.ajax({
              url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period=30days',
              dataType: 'jsonp',
              success: function(results){
                  drawChart(results)
                  popularDay(results)
                  newDate(results, "from")
                  newDate(results, "to")
                }
          });

          $.ajax({
              url: 'https://touch-rate.com/o/analytics/dashboard?api_key='+key+'&app_id='+id+'&period=30days',
              dataType: 'jsonp',
              success: function(data){
                  numberOfStores(data, "30days")
                  averageTime(data)
               }
          });

          $.ajax({
            url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Categories&segmentation=title&period=30days',
            dataType: 'jsonp',
            success: function(data4){
              allCategories(data4, 1, 1)
              allCategories(data4, 2, 2)
              allCategories(data4, 3, 3)
            }
          });

            $.ajax({
              url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Subcategories&segmentation=title&period=30days',
              dataType: 'jsonp',
              success: function(data5){
                allSubcategories(data5, 1, 1)
                allSubcategories(data5, 2, 2)
                allSubcategories(data5, 3, 3)
              }
            });


            $.ajax({
              url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Products&segmentation=title&period=30days',
              dataType: 'jsonp',
              success: function(data5){
                allProducts(data5, 1, 1)
                allProducts(data5, 2, 2)
                allProducts(data5, 3, 3)
              }
            });



          $.ajax({
              url: 'https://touch-rate.com/o?method=user_details&api_key='+key+'&app_id='+id+'&period=30days',
              dataType: 'jsonp',
              success: function(data3){
                  maxStore(data3)
              }
          });

          $.ajax({
            url: 'https://touch-rate.com/o/analytics/dashboard?api_key='+key+'&app_id='+id,
            dataType: 'jsonp',
            success: function(data){
              period(data, "30days")
            }
          });


      }); // end of 30days button


      $('.calendar').click(function(){
          var fromCalendar = document.getElementById("from").value
          var toCalendar = document.getElementById("to").value
            var f = new Date(fromCalendar).getTime()
            var t = new Date(toCalendar).getTime()
            console.log(fromCalendar)
            $('#month').html("")
            $('.results1').html("")
            $('.results2').html("")
            $('.results3').html("")
            $('.results4').html("")
            $('.results5').html("")
            $('.results7-1').html("")
            $('.results7-2').html("")
            $('.results7-3').html("")
            $('.results8-1').html("")
            $('.results8-2').html("")
            $('.results8-3').html("")
            $('.results9-1').html("")
            $('.results9-2').html("")
            $('.results9-3').html("")
            $('.time-period').html("")
            $('.jsfrom').html("")
            $('.jsto').html("")
            $('.jsfrom').append(fromCalendar)
            $('.jsto').append(toCalendar)
            $.ajax({
                url: 'https://touch-rate.com/o/analytics/sessions?api_key='+key+'&app_id='+id+'&period=['+f+','+t+']',
                dataType: 'jsonp',
                success: function(results){
                    sessionsNumber(results)
                    drawChart(results)
                    popularDay(results)
                  }
            });

            $.ajax({
                url: 'https://touch-rate.com/o/analytics/dashboard?api_key='+key+'&app_id='+id+'&period=['+f+','+t+']',
                dataType: 'jsonp',
                success: function(data){
                    // numberOfStores(data, "7days")
                    averageTime(data)
                 }
            });

            $.ajax({
              url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Categories&segmentation=title&period=['+f+','+t+']',
              dataType: 'jsonp',
              success: function(data4){
                allCategories(data4, 1, 1)
                allCategories(data4, 2, 2)
                allCategories(data4, 3, 3)
              }
            });

              $.ajax({
                url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Subcategories&segmentation=title&period=['+f+','+t+']',
                dataType: 'jsonp',
                success: function(data5){
                  allSubcategories(data5, 1, 1)
                  allSubcategories(data5, 2, 2)
                  allSubcategories(data5, 3, 3)
                }
              });


              $.ajax({
                url: 'https://touch-rate.com/o?method=events&api_key='+key+'&app_id='+id+'&event=Products&segmentation=title&period=['+f+','+t+']',
                dataType: 'jsonp',
                success: function(data5){
                  allProducts(data5, 1, 1)
                  allProducts(data5, 2, 2)
                  allProducts(data5, 3, 3)
                }
              });



            $.ajax({
                url: 'https://touch-rate.com/o?method=user_details&api_key='+key+'&app_id='+id+'&period=['+f+','+t+']',
                dataType: 'jsonp',
                success: function(data3){
                    maxStore(data3)
                }
            });

            $.ajax({
              url: 'https://touch-rate.com/o/analytics/dashboard?api_key='+key+'&app_id='+id,
              dataType: 'jsonp',
              success: function(data){
                period(data, "7days")
              }
            });

        }); // end of calendar

}); // end of doc ready



function validate(){
   if ($('#from').val().length   ===   10   &&
       $('#to').val().length  ===   10 ) {
       $(".calendar").prop("disabled", false);
   }
   else {
    //  console.log("gdfgdfg")
       $(".calendar").prop("disabled", true);
   }
}

(function() {
  function displayTransitInfo(routes) {
    var length = transitInfo.length;
    for (var i = 0; i < length; i = i+1) {
      var itemInfo = transitInfo[i]

      // Route information
      routeInfoDiv = getRouteDiv(itemInfo.route.title)

      // Schedule
      var scheduleTableBody = routeInfoDiv.find('table.table tbody');
      var scheduleLength = itemInfo['values'].length;
      for (var j = 0; j < scheduleLength; j = j+1) {
        var bus = itemInfo['values'][j]
        var busRow = $('<tr />', {});
        busRow.appendTo(scheduleTableBody);

        // Direction
        $('<td />', {
          'text': bus.direction.title,
        }).appendTo(busRow);

        // Arrival time in minutes
        arrivalTime = bus.minutes > 0 ? bus.minutes : 'now';
        $('<td />', {
          'text': arrivalTime
        }).appendTo(busRow);
      }
      routeDiv.appendTo('#transit-info');
    }
    hideWelcomeSpan();
  };

  function hideWelcomeSpan() {
    $('#welcome').hide();
  };

  function getRouteDiv(title) {
    routeDiv = $('<div />', {
      'class': 'panel panel-default'
    });
    routeDiv.append($('<div />', {
      'class': 'panel-heading'
    }).append($('<h3 />', {
      'class': 'panel-title',
      'text': title
    })));

    routeDiv.append($('<div />', {
      'class': 'panel-body'
    }));

    routeDiv.append($('<table />', {
      'class': 'table'
    }).append(
    '<thead>' +
    '<tr>' +
    '<th>Direction</th>' +
    '<th>Arrival (in minutes)</th>' +
    '</tr>' +
    '</thead>').
    append($('<tbody />', {})));

    return routeDiv;
  };

  angular.module(transitTipsApp, []) {
    .controller('TransitController', function($scope, $q) {
      _getInfo = function() {
        var showLocation = function(position) {
          var myStops = stops({
            'latitude': position.coords.latitude,
            'longitude': position.coords.longitude,
            'deferred': $q.defer()
          });

          myStops.populate();
          // $('span#latitude').text(latitude);
          // $('span#longitude').text(longitude);

          // getStops(latitude, longitude);
        }

        var getStops = function(latitude, longitude) {
          var myStops = stops({
            'latitude': latitude,
            'longitude': longitude,
            'deferred': $q.defer()
          });

          myStops.populate();
        }

        var func = function() {
          navigator.geolocation.getCurrentPosition(showLocation);
        };

        setTimeout(func, 1000);

        return deferred.promise;
      }

      _getInfo().then(function (info) {
        $scope.routes = info;
      });
    });
  }
})();

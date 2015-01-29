(function() {
  stops = function(spec, my) {
    my = my || {};

    // parameters
    var latitude = spec['latitude'];
    var longitude = spec['longitude'];
    var deferred = spec['deferred'];

    // private variables
    var that = {};

    // Public properties
    that.latitude = function() {
      return latitude;
    };

    that.longitude = function() {
      return longitude;
    };

    that.stops = [];

    that.routes = [];

    // Public methods
    that.populate = function() {
      $.ajax({
        'url': stops_url(latitude, longitude),
        'type': 'GET',
        'success': parse_response
      });
    };

    // Private methods
    var parse_response = function(data) {
      that.stops = data;
      that.routes = getTransitInfo(data);

      deferred.resolve(that.routes);
    };

    var getTransitInfo = function(transitInfo) {
      var routes = {};

      var length = transitInfo.length;
      for (var i = 0; i < length; i = i+1) {
        var itemInfo = transitInfo[i]

        var route = {};
        route['title'] = itemInfo.route.title;
        route['buses'] = [];

        // Schedule
        var scheduleLength = itemInfo['values'].length;
        for (var j = 0; j < scheduleLength; j = j+1) {
          var bus = {};
          var unprocessedBus = itemInfo['values'][j]

          // Name of bus or direction
          bus['title'] = unprocessedBus.direction.title;

          // Arrival time in minutes
          arrivalTime = unprocessedBus.minutes > 0 ? unprocessedBus.minutes : 'now';

          route['buses'].push(bus);
        }

        routes.push(route);
      }

      return routes;
    };

    var stops_url = function(latitude, longitude) {
      return "http://restbus.info/api/locations/" +
      latitude + "," + longitude + "/predictions"
    };

    return that;
  };
})();

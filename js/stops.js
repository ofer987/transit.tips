stops = function(spec, my) {
  my = my || {};

  // parameters
  var latitude = spec['latitude'];
  var longitude = spec['longitude'];
  var displayStopsFunc = spec['displayStops'];

  // private variables
  var stops = [];
  var that = {};

  // Public properties
  that.latitude = function() {
    return latitude;
  };

  that.longitude = function() {
    return longitude;
  };

  that.stops = [];

  // Public methods
  that.populate = function() {
    $.ajax({
      'url': stops_url(latitude, longitude),
      'type': 'GET',
      'success': parse_response
    });
  };

  // Private methods
  stops_url = function(latitude, longitude) {
    return "http://restbus.info/api/locations/" +
      latitude + "," + longitude + "/predictions"
  };

  parse_response = function(data) {
    that.stops = data;
    displayStopsFunc(data);
  };

  return that;
};

(function() {
  angular.module('transitTipsApp', []) {
    .controller('TransitController', function($scope, $q) {
      _getInfo = function() {
        var deferred = $q.defer();

        var showLocation = function(position) {
          var myStops = stops({
            'latitude': position.coords.latitude,
            'longitude': position.coords.longitude,
            'deferred': deferred
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

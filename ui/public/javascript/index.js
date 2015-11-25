console.log("hello world");

var tacoTruck = angular.module('tacoTruck', []);

function locationsController($scope, $http) {
  $scope.formData = {};

  // when landing on the page, get all todos and show them
  $http.get('http://localhost:3000/api/v1/locations')
    .success(function (data) {
      $scope.locations = data;
      console.log(data);
    })
    .error(function (data) {
      console.log('Error: ' + data);
    });
}

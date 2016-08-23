module.exports = angular.module('app.directives',[])
.directive 'hideTabs', ($rootScope)->
    {
        restrict: 'A'
        link: (scope, element, attributes)->
            scope.$on '$ionicView.beforeEnter', ->
                scope.$watch attributes.hideTabs, (value)->
                    $rootScope.hideTabs = value
            scope.$on '$ionicView.beforeLeave', ->
                $rootScope.hideTabs = false
    }

.directive 'editorFooter', ->
    {
        restrict: 'EA'
        templateUrl:'directives/editor-footer.html'
        controller: ($scope, $element,EditorFunction)->
            EditorFunction $scope
    }
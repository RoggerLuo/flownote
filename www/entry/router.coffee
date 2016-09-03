#不加module.exports angular就找不到 报错，加了就不报错，这是为什么啥，原理还没有搞清楚
module.exports = angular.module('app.router',[])
.config ($stateProvider, $urlRouterProvider) ->

    $stateProvider
        .state 'tab', 
            url: '/tab'
            abstract: true
            templateUrl: 'entry/tabs.html'
        .state 'tab.thread', 
            url: '/thread'
            views: 
                'tab-thread': 
                    templateUrl: 'thread/bricks.html'
                    controller: 'bricksCtrl'
        .state 'tab.threadtabs', 
            url: '/threadtabs'
            abstract: true
            cache:false
            views: 
                'tab-thread': 
                    templateUrl: 'thread/threadtabs.html'
        .state 'tab.threadtabs.plan', 
            url: '/plan'
            cache:false
            views: 
                'plan': 
                    templateUrl: 'article/plan.html'
                    controller:'planCtrl'
        .state 'tab.threadtabs.hover', 
            url: '/hover'
            cache:false
            views: 
                'hover': 
                    templateUrl: 'article/hover.html'
                    controller: 'hoverCtrl'
        .state 'tab.threadtabs.common', 
            url: '/common'
            cache:false
            views: 
                'common': 
                    templateUrl: 'article/common.html'
                    controller: 'commonCtrl'
        # .state 'tab.threadtabs.editor', # 改 editor 
        #     url: '/editor'
        #     cache:false
        #     views: 
        #         'hover': 
        #             templateUrl: 'article/editor.html'
        #             controller: 'editorCtrl'
        .state 'tab.retrospect', 
            url: '/retrospect'
            views: 
                'retrospect': 
                    templateUrl: 'retrospect/retrospect.html'
                    controller: 'retrospect'

        .state 'tab.articleTypeList', 
            url: '/articletypelist/:type' 
            cache:false
            views: 
                'retrospect': 
                    templateUrl: 'retrospect/article-list.html'
                    controller: 'articleTypeList'
        .state 'tab.articleSEList', 
            url: '/articleSEList/:string' 
            cache:false
            views: 
                'retrospect': 
                    templateUrl: 'retrospect/article-list.html'
                    controller: 'articleSEList'
        
        .state 'tab.setting', 
            url: '/setting'
            views: 
                'setting': 
                    templateUrl: 'setting/setting.html'
                    controller: 'settingCtrl'
        .state 'tab.thread-editor', 
            url: '/threadeditor'
            views: 
                'setting': 
                    templateUrl: 'setting/thread-list.html'
                    controller: 'threadEditor'
        
        .state 'tab.calendarDay', 
            url: '/calendarDay/:week'
            cache:false
            views: 
                'calendar': 
                    templateUrl: 'calendar/calendarDay.html'
                    controller: 'calendarDay'
        .state 'tab.calendarWeek', 
            cache:false
            url: '/calendarweek/:month'
            views: 
                'calendar': 
                    templateUrl: 'calendar/calendar-week.html'
                    controller: 'calendarWeek'
        .state 'tab.calendarMonth', 
            cache:false
            url: '/calendarmonth'
            views: 
                'calendar': 
                    templateUrl: 'calendar/calendar-month.html'
                    controller: 'calendarMonth'

        .state 'tab.articlelist', 
            url: '/articlelist/:day'
            cache:false
            views: 
                'calendar': 
                    templateUrl: 'calendar/article-list-by-day.html'
                    controller: 'articleListByDay'

        

    $urlRouterProvider.otherwise '/tab/calendarDay/'

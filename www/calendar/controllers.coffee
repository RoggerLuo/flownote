module.exports = angular.module('calendar.controller',[])

.controller 'articleListByDay',($scope,$stateParams,FillScopeArticles,EditorModal,TimeKit,GlobalVar,UpdateDailySummary)->
    EditorModal $scope
    FillScopeArticles $scope,day:$stateParams.day
    $scope.dateInChinese =  TimeKit.textToChinese($stateParams.day)#当前日期,传入当前 时间会错，有时候浏览器的时区不对，###统一传入text###
    
    GlobalVar.calendar.weekArr.forEach (el,index,arr)->
        if el.date == $stateParams.day
            $scope.summaryObj = arr[index]

    $scope.origin = $scope.summaryObj.summary
    $scope.$on "$ionicView.leave", (event, data)->
        if $scope.summaryObj.summary isnt $scope.origin
            UpdateDailySummary($stateParams.day,$scope.summaryObj.summary).then((res)->
                console.log "updateDailySummary成功"
            ,(res)->
                console.log "updateDailySummary失败"
            )

.controller 'calendarDay',($scope,$stateParams,FillScopeArticles,EditorModal,TimeKit,GetDailySummary,GlobalVar,GetWeeklySummary,UpdateWeeklySummary)->
    now = TimeKit.getNowDate() #当前时间yyyy-mm-dd, 传入当前时间会错，有时候时区不对，统一传入不带小时的日期
    # 处理参数
    if $stateParams.week==''
        currentWeek = TimeKit.getYearWeek(now)# 当前周
        weekstart = TimeKit.getCertainWeekStartDate now 
    else
        currentWeek = TimeKit.getYearWeek($stateParams.week)# 当前周
        weekstart = $stateParams.week #传入这个星期的第一天
    
    if GlobalVar.calendar.weekstart isnt weekstart 
        weekArr = TimeKit.wholeWeek(weekstart).filter (el)-> #统一传入text
            Date.parse(now) >= Date.parse(new Date(el.date))
        .reverse()
        $scope.days = weekArr
        GetDailySummary(weekstart).then((res)->
            # 先做一个一个temp数组
            tempData = {}
            res.data.forEach (el,index,arr)->
                tempData[el.date] = el.summary
            weekArr.forEach (el,index,arr)->
                arr[index].summary = tempData[arr[index].date]
            
            GlobalVar.calendar.weekArr = weekArr
            GlobalVar.calendar.weekstart = weekstart
            console.log "getDailySummary成功"
        ,(res)->
            console.log "getDailySummary失败"
        )
    else
        $scope.days = GlobalVar.calendar.weekArr
    
    
    # $scope.stuff = GlobalVar.calendar.config.stuff
    # $scope.color = GlobalVar.calendar.config.color
    
    # weekly数据
    $scope.weeksummaryObj={}
    GetWeeklySummary(currentWeek,currentWeek).then (res)->
        if res.data[0]?
            $scope.weeksummaryObj.summary = res.data[0].summary
            $scope.weekorigin = res.data[0].summary
    
    $scope.$on "$ionicView.beforeLeave", (event, data)->
        if $scope.weeksummaryObj.summary isnt $scope.weekorigin
            UpdateWeeklySummary(currentWeek,$scope.weeksummaryObj.summary).then((res)->
                console.log "updateWeelySummary成功"
            ,(res)->
                console.log "updateWeelySummary失败"
            )


    #Article
    weekStart = TimeKit.getCertainWeekStartDate(now) #获取这周起始日期     
    FillScopeArticles $scope,week:weekStart
    
    #编辑器Init
    EditorModal $scope


.controller 'calendarMonth',($scope,$location,$ionicHistory,EditorModal)->
    EditorModal $scope

    now = new Date() #当前日期 2016
    nowMonth = now.getMonth()+1 #当前月 
    MonthArr = while nowMonth>0
        nowMonth--
    $scope.months = MonthArr

    $ionicHistory.nextViewOptions disableBack: true #放在全局?
    $scope.redirect = (addr)->
        $location.path addr

.controller 'calendarWeek',($scope,$stateParams,EditorModal,TimeKit,ArticleListMethod,GetWeeklySummary)->
    EditorModal $scope
    ArticleListMethod $scope
    # 处理参数，week获得一个月份，然后展示这个月份的 weeks
    if $stateParams.month==''
        thistime = new Date()
        nowMonthRealWorld = thistime.getMonth()+1 #为了给 month设定一个默认值
    else
        nowMonthRealWorld = $stateParams.month 
    nowMonth = nowMonthRealWorld - 1 #机器识别的month比现实生活中的month小1，容易搞错
    
    monthStartDate = TimeKit.getCertainMonthStartDate nowMonth
    monthEndDate = TimeKit.getCertainMonthEndDate nowMonth
    
    firstWeek = TimeKit.getCertainWeekStartDate(monthStartDate[0]) #第一周的第一天
    firstWeekNum = TimeKit.getYearWeek(monthStartDate[0])#这个月第一周的 周数
    lastWeekNum = TimeKit.getYearWeek(monthEndDate[0])#这个月最后一周的 周数
    i = firstWeekNum
    weekRawArr = while i<=lastWeekNum
        {
            weekNum: 1 + i++
            startDate:TimeKit.dateAdd firstWeek,(i-firstWeekNum)*7
            endDate:TimeKit.dateAdd firstWeek ,6+ (i-firstWeekNum)*7
        }
    now = TimeKit.getNowDate() # 当前日期,传入当前 时间会错，有时候浏览器的时区不对，###统一传入text###
    weekArr = weekRawArr.filter (el,index,arr)->
        Date.parse(new Date(now)) >= Date.parse(new Date(el.startDate))
    .reverse()
    $scope.weeks = weekArr
    

    GetWeeklySummary(firstWeekNum,lastWeekNum).then (res)->
        tempData = {}
        res.data.forEach (el,index,arr)->
            tempData[el.weeknumber] = el.summary
        
        weekArr.forEach (el,index,arr)->
            arr[index].summary = tempData[el.weekNum]
        # if res.data[0]?
        #     $scope.weeksummaries = res.data



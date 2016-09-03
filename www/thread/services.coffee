module.exports=angular.module 'thread.services',[]
.factory 'ThreadViewModel',($ionicModal,CreateThread,ModifyThread,ThreadDelete,GlobalVar)-> 
    execute = ($scope)->
        ###########
        ## Modal ##
        ###########
        # Modal data and logic
        $scope.originalThreadData = {}
        $scope.editData =
            thread_text:''
            color:'button-stable'
            stuff:'false'
            thread_id:'new'

        $scope.cancelThreadView = ->
            $scope.editData.text=$scope.originalThreadData.text
            $scope.editData.color=$scope.originalThreadData.color
            $scope.editData.stuff=$scope.originalThreadData.stuff
            $scope.threadViewModal.hide()
            $scope.editData =
                thread_text:''
                color:'button-stable'
                stuff:'false'
                thread_id:'new'

        $ionicModal.fromTemplateUrl 'thread/thread-modal.html', {
            scope: $scope,
            animation: 'slide-in-up'
            }
        .then (modal) ->
            $scope.threadViewModal = modal
        
        $scope.openThreadViewModal = (thread) ->
            $scope.threadViewModal.show()
            if thread?
                $scope.editData = thread
                $scope.originalThreadData = JSON.parse JSON.stringify thread 
        
        $scope.closeThreadViewModal = ->
            $scope.threadViewModal.hide()


        $scope.$on '$destroy', ->
            $scope.threadViewModal.remove()
        
        $scope.$on 'modal.hidden', ->
            true    
        $scope.$on 'modal.removed', ->
            true

        $scope.createThread=->
            if $scope.editData.thread_text ==""
                return  false
            if $scope.editData.thread_id == 'new'  # 增
                obj = CreateThread $scope.editData
                $scope.bricks.unshift obj                      
            else                                 # 改
                if $scope.originalThreadData.thread_text!=$scope.editData.thread_text||$scope.originalThreadData.color!=$scope.editData.color||$scope.originalThreadData.stuff!=$scope.editData.stuff
                    ModifyThread $scope.editData
            $scope.editData =
                thread_text:''
                color:'button-stable'
                stuff:'false'
                thread_id:'new'
                
        $scope.removeThread = (thread) -> # 删
            r = confirm "请先清空分类下的文章,确定要删除"+thread.thread_text+"?"
            if r
                $scope.bricks.splice $scope.bricks.indexOf(thread), 1
                ThreadDelete thread

        $scope.openThreadViewModalDelegate = ->
            $scope.openThreadViewModal GlobalVar.thread

    execute
.factory 'ThreadsHandler',(Resource,GlobalVar)->
    execute = (callback)->
        # 貌似一用storage就坏事
        # if storage.getItem "all_threads_list"
        #     data = GetThreadsFromStorage()
        #     GlobalVar.bricks = data
        #     callback data
        # else

        if GlobalVar.bricks?
            callback GlobalVar.bricks
        else
            promise = Resource.query method:'download_thread' 
            .$promise
            promise.then (res)->
                if res.data?
                    GlobalVar.bricks = res.data
                else
                    GlobalVar.bricks = []
                GlobalVar.bricks.reverse()
                GlobalVar.bricks.unshift
                    thread_text:'Roger'
                    color:'button-stable'
                    stuff:false
                    item_list:[]
                    thread_id:0
                    item_number:0
                    father_id:0
                callback GlobalVar.bricks
                # storeThread res.data
            ,(res)->
                # debugger
                true
    execute

.factory 'CreateThread',(Resource) -> #增
    storage=window.localStorage        
    execute=(editData)->
        date_and_time=Date.parse(new Date())/1000
        thread_obj=
            thread_text:editData.thread_text
            color:editData.color
            stuff:editData.stuff
            thread_id:date_and_time.toString()

        thread_id=thread_obj.thread_id
        thread_text=thread_obj.thread_text
        color=thread_obj.color
        stuff=thread_obj.stuff

        #接下来该些Resource 8月19日
        promise = Resource.query({method:'thread_create',thread_id:thread_id,thread_text:thread_text,color:color,stuff:stuff}).$promise
        
        promise.then((res)->
            console.log "添加thread成功"
            #应该弹出一个footer
        ,(res)->
            #报错提示
            console.log "添加失败"
        )
        thread_obj
    execute


.factory 'ModifyThread',(Resource) -> # 改
    storage=window.localStorage        
    execute = (thread_obj)->
        thread_id = thread_obj.thread_id.toString()
        thread_text=thread_obj.thread_text
        color=thread_obj.color
        stuff=thread_obj.stuff
        #单个修改localstorage
        storage.setItem "thread"+thread_id,JSON.stringify thread_obj

        promise = Resource.query({method:'thread_modify',thread_id:thread_id,thread_text:thread_text,color:color,stuff:stuff}).$promise
        promise.then((res)->
            #footer提醒
            console.log "修改thread成功"
            true
        ,(res)->
            #warning提醒
            console.log "修改thread失败"
            true
        )

    execute

.factory 'ThreadDelete',(Resource,RemoveFunc) -> # 删
    storage=window.localStorage        
    execute = (thread_obj)->
        thread_id=thread_obj.thread_id.toString()
        #删除thread_list
        list=JSON.parse storage.getItem "all_threads_list"
        RemoveFunc.call list,thread_id
        storage.setItem "all_threads_list",JSON.stringify list

        promise = Resource.query({method:'thread_delete',thread_id:thread_id}).$promise
        promise.then((res)->
            console.log "删除thread成功"
            true
        ,(res)->
            console.log "删除thread失败!"

            true
        )
    execute    

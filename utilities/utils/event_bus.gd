extends Node

## 记录信号与事件的字典
## {"signal_name":[callable1,callable2]}
var buss:Dictionary
var block_list=[]
var lock_list=[]

## 推送事件
func push_event(destination: String, payload = []) ->void:
	# 获取内部信号名称
	var dest_signal:String =_get_destination_signal(destination)
	
	# 需要以列表传递参数，如果不是，将其变为列表形式
	if not payload is Array:
		payload =[payload]

 	# 判断是否有信号，如果没有，则会触发提示，但是不会终止程序
	if not buss.has(dest_signal):
		printerr(destination+"目前还没有订阅者")
		return

	if event_is_block(destination):
		printerr(destination+"目前处于被阻塞状态")
		return
		
	# 遍历信号对应的方法列表
	var callables=buss[dest_signal]
	for each:Callable in callables:
		each.get_object().callv(each.get_method(),payload)
	
	# 打印信号流 不适用于以发布模式导出的项目
	var pusher_stack=get_stack()
	var pusher:String="null"
	if pusher_stack.size()>=2:
		pusher=pusher_stack[1]["source"] +' '+pusher_stack[1]["function"]
	print(pusher+" -> "+str(buss[dest_signal]))

## 订阅事件
func subscribe(destination:String,callback:Callable)-> void:
	if event_is_lock(destination):
		printerr(destination+"目前处于锁定状态，暂时不可订阅")
		return
	# 获取内部信号名称
	var dest_signal:String =_get_destination_signal(destination)
	
	# 向buss添加键值对
	if not buss.has(dest_signal):
		buss[dest_signal]=[callback]
	else:
		buss[dest_signal].append(callback)

## 取消订阅事件
func unsubscribe(destination: String, callback: Callable) -> void:
	## 获取内部信号名称
	var dest_signal: String =_get_destination_signal(destination)
	
	# 如果有该信号，继续判断
	if buss.has(dest_signal):
		# 如果信号有对应的方法，则删除
		if buss[dest_signal].has(callback):
			buss[dest_signal].erase(callback)
		else:
			printerr(destination+"没有被绑定的该方法...")
			
		# 删除完成后判断是否方法为空，如果为空就删除信号，释放空间
		if buss[dest_signal]==[]:
			buss.erase(dest_signal)
	else:
		printerr(destination+"：没有该信号...")

## 取消某一事件的所有订阅
func unsubscribe_all_unsubscribes(destination: String)->void:
	# 获取内部信号名称
	var dest_signal=_get_destination_signal(destination)
	
	var callbacks=buss[dest_signal]
	# 反向遍历
	for i in range(callbacks.size() - 1, -1, -1):
		unsubscribe(destination,buss[dest_signal][i])

## 获取事件名
func _get_destination_signal(destination:String)-> String:
	var dest_signal:String ="EventBus|%s"% destination
	if not has_user_signal(dest_signal):
		add_user_signal(dest_signal)
	return dest_signal

## 阻塞信号的发出，暂时断开信号连接
func block_event(destination:String)->void:
	# 获取内部信号名称
	var dest_signal=_get_destination_signal(destination)
	block_list.append(dest_signal)

## 取消信号的阻塞状态，恢复信号连接
func unblock_event(destination:String)->void:
	# 获取内部信号名称
	var dest_signal=_get_destination_signal(destination)
	if block_list.has(dest_signal):
		block_list.erase(dest_signal)

## 判断信号的阻塞状态
func event_is_block(destination:String)->bool:
	# 获取内部信号名称
	var dest_signal=_get_destination_signal(destination)
	return block_list.has(dest_signal)

## 冻结事件的添加订阅功能，但是可以正常取消订阅
func lock_event_relationship(destination:String)->void:
	# 获取内部信号名称
	var dest_signal=_get_destination_signal(destination)
	lock_list.append(dest_signal)

## 解冻事件的添加订阅功能
func unlock_event_relationship(destination:String)->void:
	# 获取内部信号名称
	var dest_signal=_get_destination_signal(destination)
	if lock_list.has(dest_signal):
		lock_list.erase(dest_signal)

## 判断信号的冻结状态
func event_is_lock(destination:String)->bool:
	var dest_signal=_get_destination_signal(destination)
	return lock_list.has(dest_signal)


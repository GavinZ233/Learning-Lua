print("******************协程的创建****************")
--coroutine.create()
fun=function()
	print(321)
end
co=coroutine.create(fun)
--协程是一个线程对象
print(co)
print(type(co))
--co的类型是thread

--coroutine.wrap()
co2=coroutine.wrap(fun)
print(co2)
print(type(co2))
--co2的类型是function
print("******************协程的运行****************")
--第一种方法，通过create创建的协程
coroutine.resume(co)

--第二种方法
co2()

print("******************协程的挂起****************")
fun2=function(x)
	i=0
	while true do
		i =i+x
		print("i:"..i)
		print(coroutine.status(co3))
		print(coroutine.running())

		--协程的挂起
		coroutine.yield(i)
	end
end

co3=coroutine.create(fun2)
print(coroutine.resume(co3,1))
isOK,tempI=coroutine.resume(co3,10)
print("返回值",isOK,tempI)
--默认返回一个boolean值表示是否执行成功，后面再返回反参
coroutine.resume(co3,10)
coroutine.resume(co3,10)
--因为yield将协程挂起了，需要resume重启

co4=coroutine.wrap(fun2)
isOK,tempI=co4(321)
print("返回值",isOK,tempI)
--只返回反参
co4()
co4()
co4(1)
co4(50)



print("******************协程的状态****************")

--coroutine.status(协程的状态)
--dead 结束
--suspended 暂停
--running 运行

print(coroutine.status(co3))

--可以得到当前运行的协程的线程号
print(coroutine.running())

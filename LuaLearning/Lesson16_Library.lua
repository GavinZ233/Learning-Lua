print("******************时间*****************")

--系统时间(单位s)
print(os.time())
--传入日期得到s
print(os.time({year=2014,month=2,day=3}))

local nowTime=os.date("*t")
for k,v in pairs(nowTime) do
	print(k,v)
end
print(nowTime.min)


print("******************数学*****************")
--math
print(math.abs(-11))
--弧度转角度
print(math.deg(math.pi))
--三角函数,传弧度
print(math.cos(math.pi))

print(math.floor(2.6))
print(math.ceil(5.1))


print(math.max(1,2))
print(math.min(4,5))


print(math.modf(1.2))


print(math.pow(2,5))


--随机数，先设置种子
math.randomseed(os.time())
print(math.random(300))--第一个是根据种子本身生成，种子改变了才会改变
print(math.random(300))--第二个是根据种子信息生成，种子信息改变就会改变



print(math.sqrt(9))

print("******************路径*****************")

print(package.path)



















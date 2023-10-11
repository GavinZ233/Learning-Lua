print("******************特殊用法******************")
print("******************多变量赋值******************")
a,b,c=1,false,"ghj"
print(a)
print(b)
print(c)


a2,b2,c2=3,9,"iu",true
print(a2)
print(b2)
print(c2)
--多的值舍弃
a3,b3,c3=3,9
print(a3)
print(b3)
print(c3)
--少的值补nil




print("******************多返回值******************")

function Test()
	return 1,2,3,"ghj"
end
a,b,c,d,e=Test()
print(a)
print(d)
print(e)


print("******************and or******************")

--and or 可以连接任何
--lua中，只有nil和false才是假

print(1 and false)
--短路原理，先判断and前是否为真，1为真，返回and后的false

print(1 or 2)
--短路原理，先判断1是否为真，1为真，返回1不需要执行or后的2
print(nil or false)
print(1 or false)
print(false or nil)
--false为假，返回nil

--以此可以手写一个三目运算

x=3
y=1
res= (x>y) and x or y 
--x大于y，返回x，=> x or y
--x 为真，返回x
--达到了（）内为真，返回x的效果
print(res)
res= (x<y) and x or y 
--x不小于y，返回false，=> false or y
--false跳过，返回y
--达到了（）内为假，返回y的效果
print(res)







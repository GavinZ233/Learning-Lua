print("******************模拟class******************")

--表实现类

Student ={
	age=1,
	sex=true,
	Up =function()
		print("up了")
	end	
}

print(Student.age)
Student.Up()

Student.name="吴彦祖"

print(Student.name)

function Student.Speak()
	print("speak"..Student.age)
end

--在表内部调用表的属性或者方法，要指明是谁的

Student.Speak()

function Student:Learn()
	print("Learn"..self.name)
end

--点调用方法，需要指定参数

--冒号调用，会默认把调用者做第一个参数传入
Student:Learn()

--self代表默认传入的参数

print("**************表的公共操作***************")

t1={{age=1,name="123qwe"},{age=2,name="ewq321"}}

t2={name="吴彦祖",sex=true}
print("###########插入##########")
print(#t1)
table.insert(t1,t2);
table.insert(t1,1,t2)
print(t1[1].name)
print(#t1)

print(t1[1])
print(t1[2])
print(t1[3])
print(t1[3].sex)
print("###########移除##########")

table.remove(t1)
print(t1[1].name)
--remove无第二个参数时会默认移除最后一个
table.remove(t1,1)
print(t1[1].name)

for k,v in pairs(t1) do
	print(k,v)
end
print("###########升序排序##########")
--排序默认是升序排列
t3={3,5,6,2}
table.sort( t3)
for _,v in pairs(t3) do
	print(v)
end
print("###########降序排序##########")

--传入排序规则函数，前数大于后数，即降序排列
table.sort(t3, function(a,b)
	if a>b then
		return true
	end
end
	)

for _,v in pairs(t3) do
	print(v)
end


print("###########拼接##########")

tb={"sadf","asdf","sadf"}
--链接函数，用于拼接表中元素返回一个字符串
str=table.concat( tb, " ",2,3)
print(str)
--只能拼接字符串与数字
str=table.concat(t2,"")
print(str)


--常用是插入与移除
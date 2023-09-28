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









print("********************************")
a={1,2,3,"213",nil,true}

--lua的索引从1开始
--打印长度时，尾部的空被省略
print(#a)
for i=1,#a do
	print(a[i])
end

b={{1,3,5},{2,3,5}}
for i=1,#b do
	c=b[i]
	for j=1,#c do
		print(c[j])
 	end
end

aa={[0]=1,2,3,[4]=4,[6]=5}
print(aa[0])
print(aa[6])
print(#aa)
--数字自定义索引间断一位时，系统会在空缺位补空，缺两位以上时，系统舍弃后续索引
 

--冒泡排序
a={3,4,1,6,72,3}
print("输出数组******************")
for i=1,#a do
	print(a[i])
end

for i=1,#a do
	for j=#a,i,-1 do
		if (a[i]>a[j]) then
			value=a[i]
			a[i]=a[j]
			a[j]=value
		end
	end
end

print("输出有序数组******************")
for i=1,#a do
	print(a[i])
end

t={4,[1]=2,[3]=3,4}
--ipairs 类似#获取到长度根据长度遍历
for i,v in ipairs(t) do
	print(i,v)
end
print("-------------")
--pairs 将table所有键都找到
for k,v in pairs(t) do
	print(k,v)
end

--表的增删改
c={["name"]="吴彦祖",["age"]=26}

print(c.name)
c["name"]="曾志伟"--直接赋值就是修改
print(c.name)

c["money"]=3--直接声明就是新增
print(c.money)

c["money"]=nil--置空就相当于删除
print(c.money)

for k,v in pairs(c) do
	--可以传多个参数，一样可以打印
	print(k,v,3,4)
end
--声明_下划线代替key的参数获取，只打印value
for _,v in pairs(c) do
	print(v)
end




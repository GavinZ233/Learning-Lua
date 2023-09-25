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














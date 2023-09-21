print("************while***********")
num=0
while num<5 do
	print(num)
	num=num+1
end

print("************do while***********")
num=0
repeat
	print(num)
	num=num+1
until num>5


print("************for***********")

for i=1,10 do -- 默认自增
	print(i)
end

for i=1,10,2 do
	print(i)
end
print("**************多脚本执行***************")
print("**************全局变量和本地变量***************")
--全局变量
a=1
b="lkj"

for i=1,10 do
	c='asd'
end

print(c)

for i=1,10 do
	local	d="jhg"
end

print(d)

--只要不加local，都是全局变量

print("**************多脚本执行***************")
--关键字 require（"脚本名"） require('脚本名')
require("Test")		--执行脚本
print(TestNum)		--全局属性可以访问
print(TestLoaclNum) --本地属性无法访问

print("第二次执行Test")
require('Test')
--无法重复执行脚本

--package.loaded['脚本名']
--返回该脚本是否执行
print(package.loaded['Test'])
--卸载已经执行过的脚本（将该loade置空）
package.loaded["Test"]=nil
print(package.loaded['Test'])
print("已卸载Test")
--执行一个脚本时，可以在脚本最后返回一个外部希望获取的内容
testloaclnum=require("Test")
--卸载后重新执行脚本
print(testloaclnum)
print("**************G表***************")
-- _G表是总表，将所有申明的全局变量存储
for k,v in pairs(_G	) do
	--print(k,v)
end




















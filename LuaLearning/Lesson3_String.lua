print("**********字符串**********")
str="字符串"

print("***********字符串长度****************")
s1="abcd"
print(#s1)
s2="abcd中文"
print(#s2)
--一个汉字占3个长度

print("***********字符串多行打印****************")
print("使用转义字\n符换行")

s=[[在字符串
里
换行]]
print(s)

print("***********字符串拼接****************")
print("字符串".."拼接")

s1="拼接数字" s2=321
print(s1..s2)

print(string.format("使用format拼接数字%d。",213))
print(string.format("使用format拼接数字%s。","asdaf"))

--%d:数字拼接
--%s:字符配对

print("***********其他类型转字符串****************")
a = true
print(tostring(a))
--print会自动把目标变量tostring

print("***********字符串的公共方法****************")

str="asdfSAD"
print(string.upper(str))
print(str)
print(string.lower(str))
print(string.reverse(str))
print(string.find(str,"as"))
--lua的索引从1开始
--find返回的结果是两个，第一个是起点，第二个是结尾
print(string.sub(str,2,4))
--sub,传一个参数是从该起点到结尾截取，传两个参数就是截取的起点和终点
print(string.rep(str,2))
--重复字符串指定次数
print(string.gsub(str,"SA","*……*"))
--替换字符串，返回替换次数

--字符转ASCII码
a=string.byte("lua",1)--字符串指定位置（默认第一位）转码
print(a)
print(string.char(a))



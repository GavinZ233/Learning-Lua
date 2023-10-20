print('执行Test')


testNumber=5
testBool=true
testFloat=3.15926
testString="string啊啊啊啊"


--无参无返回
testNoINAndOUT =function ()
	print("无参无返回")
end



--有参有返回
testHasINAndOUT =function (a)
	print("有参有返回"..a)
	return a+1
end


--多返回值
testMultipleOUT =function (a)
	print("多返回值"..a)
	return 3,"wqe",false
end


--变长参数

testMultipleIn =function (...)
	args={...}
	print("变长参数")
	for k,v in pairs(args) do
		print(k,v)
	end
end



testList={1,2,3,4,5}
testArray={"wqe",321,true}

testDic={
	["1"]=1,
	["2"]=14,
	["3"]=21,
	["4"]=45
}
testDic2={
	["1"]=true,
	[true]=1,
	[false]=0,
	["a"]="abcd"

}




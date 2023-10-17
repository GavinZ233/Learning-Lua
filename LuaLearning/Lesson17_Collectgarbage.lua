print("************垃圾回收**************")

test={fsafafafg=33535312515,rwe="ewrwerwerwet",asd=423432432432.324324}
--垃圾回收关键字
--collectgarbage
--获取当前lua占用内存数 k字节 用返回值*1024 得到内存占用字节数
print(collectgarbage("count"))

test=nil
collectgarbage("collect")

print(collectgarbage("count"))













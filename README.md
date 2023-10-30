# Learning-Lua
lua课程学习笔记



## 整体结构

|节点|内容|难点
|--|--|--
|AB包||
|Lua语法||
|xLua||
|Hotfix||
|xLua的背包系统||

## 1. AB包

### 1.1 了解AB包
|Resources|Ab包|
|--|--|
|全部打包，只读|存储位置、压缩方式自定义，可动态更新|

热更流程：客户端向服务端对比版本号获取资源服务器地址，客户端向资源服务器比对资源，检测需要更新的内容，下载对应AB包

导入AssetBundles-Browser：打开UnityPackageMgr，点+号选择URL导入： `https://github.com/Unity-Technologies/AssetBundles-Browser.git`


### 1.2 生成AB包

#### 1.2.1 创建ab包
1. 资源文件右下角的AssetBundle面板有两个下拉框，第一个选择资源要打包的ab包，第二个是在ab包内的分组

2. 查看ab包可以到Window-AssetBundles-Browser，点开的弹窗里看，每次新修改ab包需要刷新一下

#### 1.2.2 ab包打包设置
|Build参数|含义|
|--|--|
|**Build Target**|打包的目标平台|
|**Ouput Path**|ab包输出路径|
|**Clear Folders**|打包前清空路径，可以清除一些不需要的包|
|**Copy to StreamingAssets**|输出的ab包复制到StreamingAssets一份|
|**Compression**|压缩方式：1.不压缩 2.LZMA压缩最小，但解压时全部解压 3. `LZ4`压缩包体比LAZMA略大，但可以单独解压
|Exclude Type Information|在资源包中不包含资源的类型信息|
|Force Rebuild|重新打包时重新构建所有包，不会删除多余的包|
|Ignore Type Tree Changes|增量构建检查时，忽略类型树的更改|
|Append Hash|将文件的哈希值附加到资源包名上|
|Strict Mode|严格模式，如果打包报错则打包失败|
|Dry Run Build|运行时构建|

#### 1.2.3 ab包文件
|文件名|作用|
|--|--|
|包名.分组名|ab包本体|
|manifest|ab包的关联信息，资源信息，版本信息等|
|和导出文件夹同名|ab包的主包,记录依赖关系|

#### 1.2.4 UnityLearn对于AB包的介绍
（暂时空着，回头看看文章对于资源引用的介绍）    
https://learn.unity.com/tutorial/assets-resources-and-assetbundles#5c7f8528edbc2a002053b5a6


### 1.3 使用AB包资源
#### 1.3.1  同步加载AB包

1. 类型加载     

        //加载AB包,ab包不能重复加载
        AssetBundle bundle = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/" + "model");
        //加载ab包中的资源
        GameObject cube = bundle.LoadAsset("Cube", typeof(GameObject)) as GameObject;
        //实例化
        Instantiate(cube);


2. 泛型加载     
         
        //泛型加载
        GameObject cap = bundle.LoadAsset<GameObject>("Capsule");
        //实例化
        Instantiate(cap, Vector3.one, Quaternion.identity);



#### 1.3.2 异步加载AB包

        IEnumerator LoadABRes(string abName, string resName)
        {
          AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(Application.streamingAssetsPath + "/" + abName);
          yield return abcr;
          AssetBundleRequest abq = abcr.assetBundle.LoadAssetAsync(resName, typeof(Sprite));
          yield return abq;

          img.sprite = abq.asset as Sprite;
          img.rectTransform.localScale = Vector3.one * 5;
        }

>注意 ： 此处的 `AssetBundleCreateRequest` 和 `AssetBundleRequest` 类都是继承自 `AsyncOperation`，属于异步操作协同程序。    
        AssetBundleCreateRequest是创建请求，创建成功后，返回AssetBundleRequest加载请求，可以从AssetBundleRequest中得到加载成功的AB包


#### 1.3.3 卸载AB包

            //卸载所有AB包，入参为是否卸载已经加载的AB包资源
            AssetBundle.UnloadAllAssetBundles(false);

            //单个ab包卸载，入参为是否卸载已经加载的AB包资源
            bundle.Unload(true);
>实用场景中，大部分情况不会入参true


#### 1.3.4 依赖包

如果某模型的材质与模型分别打包，只加载模型的AB包，实例化出来的模型是无材质的,需要将材质所在的AB包也一并加载。

包与包之间的依赖被记录在主包中，但不会记录资源对包的依赖，只会记录包内部所有资源对外部哪些包有依赖。    
举个栗子：model包中有模型（坦克和炮弹），tanktt包中有坦克车身的贴图，tracktt包中有履带贴图，shelltt包中有炮弹的贴图。此时从model包的依赖包有tanktt、tarcktt、shelltt包，哪怕只是想加载model包中的炮弹，tanktt和tarcktt包也会因为依赖关系被一起加载。

获取依赖信息：  

        //加载主包
        AssetBundle abMain=AssetBundle.LoadFromFile(Application.streamingAssetsPath+"/" + "StandaloneWindows");
        //从主包加载依赖信息文件
        AssetBundleManifest abManifest = abMain.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        //从依赖文件中获取model的依赖包信息
        string[] strs=abManifest.GetAllDependencies("model");
        foreach (string str in strs)
        {
            print("model依赖包："+str);
        }


### 1.4 AB包资源加载Mgr

#### ABMgr类
|名称|作用|操作|
|---|---|---|
|+ ABMgr Instance|单例|访问本类时，如果为空实例化gameobject并附加本类，返回instance
|- AssetBundle mainAB|记录主包|
|- AssetBundleManifest mainifest|包依赖信息|
|- Dictionary<string,AssetBundle> abDic|记录加载的AB包|
|- string PathUrl|ab包路径地址|
|- string MainABName|主包名称|
|+ object LoadRes(string abName,string resName)|加载资源|LoadAB（abName），加载对应名称资源
|+ object LoadRes(string abName, string resName,System.Type type)|加载资源|LoadAB（abName），加载对应名称对应type的资源
|+ T LoadRes< T >(string abName, string resName)where T : Object|加载资源|（同上）泛型重载
|- LoadAB(string abName)|加载ab包|异步加载ab包|检查主包，依赖包，目标包是否已经加载，没有加载时进行异步ab包加载，并记录到abDic
|+ LoadResAsync(string abName, string resName, UnityAction< Object > callback)|对外公开异步加载方法|启动ReallyLoadResAsync（abName,resName,callback）
|- IEnumerator ReallyLoadResAsync(string abName, string resName, UnityAction< Object > callback)|异步加载资源|LoadABAsync(abName),加载resName资源
|+ LoadResAsync(string abName, string resName,System.Type type, UnityAction< Object > callback)|对外公开异步加载方法|启动ReallyLoadResAsync（abName,resName,type,callback）
|- IEnumerator ReallyLoadResAsync(string abName, string resName, System.Type type, UnityAction<Object> callback)|异步加载type类型资源|LoadABAsync(abName),加载resName资源
|+ LoadResAsync< T >(string abName, string resName, UnityAction< T > callback)where T : Object|对外公开异步加载方法|启动ReallyLoadResAsync< T >（abName,resName,callback）
|- IEnumerator ReallyLoadResAsync< T >(string abName, string resName, UnityAction< T > callback) where T : Object|异步加载T类资源|LoadABAsync(abName),加载resName资源
|- IEnumerator LoadABAsync(string abName)|异步加载ab包|检查主包，依赖包，目标包是否已经加载，没有加载时进行异步ab包加载，并记录到abDic
|+ UnLoad(string abName)|卸载ab包|卸载目标包并从abDic中移出
|+ ClearAB()|卸载所有ab包|卸载所有ab包并清空abDic和mainAB与manifest信息

此类主要对外提供：
1. 同步加载资源方法（三种重载）
2. 异步加载资源方法（三种重载）
3. 卸载AB包方法



>ab包的加载中，如果没有指定类型，会加载第一个对应名称的资源,这就需要给定类型才能避免偏差，而lua是不支持泛型的，在lua热更中就需要在提供resName后面再提供type，保证准确性


## 2. Lua语法
[Lua 5.3 参考手册](https://www.runoob.com/manual/lua53doc/contents.html)
### 2.1 lua环境
[luaforwindows](https://github.com/rjpcomputing/luaforwindows/releases) 

### 2.2 注释
> --单行注释    
--[[多行        
注释]]

### 2.3 数据类型
简单数据类型：nil，number，string，boolean      
复杂数据类型：function，table，userdata，thread
|数据类型|描述|
|--|--|
|nil|表示一个无效值，空|
|boolean|false或者true|
|number|表示双精度类型的实浮点数|
|string|字符串，双引号和单引号都是string|
|funciton|编写的函数|
|userdata|表示任意存储在变量中的C数据结构|
|thread|表示执行的独立线路，协同程序|
|table|Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字、字符串或表类型。在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。|

>lua中使用未声明的变量，默认为nil       
print(a)      
pring(type(a))  
打印:nil   nil

### 2.4 字符串操作
1. 字符串长度

       print(#str)
2. 字符串多行打印

        print("使用转义字\n符换行")
        s=[[在字符串
        里
        换行]]
        print(s)
3. 字符拼接 
        print("字符串".."拼接")

        s1="拼接数字" s2=321
        print(s1..s2)

        print(string.format("使用format拼接数字%d。",213))
        print(string.format("使用format拼接数字%s。","asdaf"))

        --%d:数字拼接
        --%s:字符配对
4. 其他类型转字符串

        a = true
        print(tostring(a))
        --print会自动把目标变量tostring

5. 字符串的公共方法

        string.upper(str)
        string.lower(str)
        string.reverse(str)
        string.find(str,"as")
        --lua的索引从1开始
        --find返回的索引结果是两个，第一个是起点，第二个是结尾
        string.sub(str,2,4)
        --sub,传一个参数是从该起点到结尾截取，传两个参数就是截取的起点和终点
        string.rep(str,2)
        --重复字符串指定次数
        string.gsub(str,"SA","*……*")
        --替换字符串，返回替换次数

        --字符转ASCII码
        a=string.byte("lua",1)--字符串指定位置（转码

### 2.5 运算符
1. 算术运算符   
>加`+`  减`-`  乘`*`  除`/`  取余`%` 幂运算`^`   
没有自增自减    
没有复合运算 += -= /=等         
print("321"+2) --字符串可以算数操作，自动转成number

2. 条件运算符   
> `>`  `<`  `<=` `>=` `==` `~=`(不等于)

3. 逻辑运算符   

|逻辑|C#|lua|
|--|--|--|
|与|&&|and
|或|\|\||or
|非|!|not


### 2.6 条件分支
        if a>5 then
                print(a.."大于"..5)
        elseif a==3 then
                print("a等于"..3)
        elseif a==2 then
                print("a等于"..2)
        elseif a==1 then
                print("a等于"..1)
        else print("idontknow")
        end
>Lua不持支switch

### 2.7 循环
1. while

        num=0
        while num<5 do
                print(num)
                num=num+1
        end
2. do while

        num=0
        repeat
                print(num)
                num=num+1
        until num>5  --直到满足，退出循环
3. for

        for i=1,10 do -- 默认+1
                print(i)
        end

        for i=1,10,2 do  --设定+2
                print(i)
        end

### 2.8 函数
> lua的函数不支持重载，新申明的函数会覆盖老的


1. 函数结构

        function  FunName()
                -- body
        end

        FunName = function()
                -- body
        end

2. 反参

        function F4(a)
                return a
        end
        temp=F4("213")
        print(temp)
3. 变长参数

        function F7(...)
                arg={...}
                for i=1 ,#arg do
                        print(arg[i])
                end
        end
        F7(3,1,4,76,"weq32")



4. 函数嵌套

        function F8()
                F9 =function() --内部声明一个函数
                        print(123);
                end
                return F9  --返回函数
        end
        f9=F8()
        f9()

        function F9(x)
                return function(y) --在return后直接申明函数
                        return x+y 
                end
        end
        print(F9(10)(1)) --调用外部函数后面加一个括号表示调用返回的函数


### 2.9 Table
>表是一切复杂数据的基础：数组，二维数组，字典，类等

#### 1. 数组 

索引从`1`开始   
长度获取:`#`Nums        
长度计算时，自动舍去末尾的nil   
当自定义索引为数字时，长度忽略小于0的，且索引间隔大于1时长度默认为断开处的索引值

自定义索引被默认索引覆盖：        
>t={[1]=1,[2]=2,[3]=3,4}        
t={4,[1]=2,[3]=3,4}     
打印 t[1] 都是4  


#### 2. 遍历方法

        --ipairs 类似#获取到长度根据长度遍历
        for i,v in ipairs(t) do
                print(i,v)
        end
        --pairs 将table所有键都找到
        for k,v in pairs(t) do
                print(k,v)
        end

        for k,v in pairs(c) do
                --可以传多个参数，一样可以打印
                print(k,v,3,4)
        end
        --声明_下划线代替key的参数获取，只打印value
        for _,v in pairs(c) do
                print(v)
        end

表的增删改      

        c={["name"]="吴彦祖",["age"]=26}

        print(c.name)
        c["name"]="曾志伟"--直接赋值就是修改
        print(c.name)

        c["money"]=3--直接声明就是新增
        print(c.money)

        c["money"]=nil--置空就相当于删除
        print(c.money)

#### 3. 表模拟类

在表内声明成员属性和方法

        Student ={
                age=1,
                sex=true,
                Up =function()
                        print("up了")
                end	
        }
但在外部也能添加

        Student.name="吴彦祖"
        --第一种声明方式
        function Student.Speak()
                print("speak"..Student.age)
        end
        --第二种声明方式
        Student.Speak=function()
                 print("speak"..Student.age)
        end

特殊的，方法调用方式有两种      
第一种默认方法

        Student.Speak()
直接点调用，如果需要传参，就在（）内写入参
>此方法调用`:`声明的方法时，第一个入参会作为self传入

第二种把调用者作为隐藏入参

        Student:Speak()
对应的方法内部会使用self关键字代表隐藏入参

        function Student:Learn()
                print("Learn"..self.name)
        end

#### 4. 表的公共方法
1. **插入**     
table.insert(被插表，插入索引，插入元素)         
无插入索引时，默认插入到 len+1处  

        table.insert(t1,t2);
        table.insert(t1,1,t2)

2. **移除**     
table.remove(要操作的表，移除索引)      
无索引时，默认移除最后一位

        table.remove(t1,1)
        table.remove(t1)

3. 排序    
table.sort(排序的表，排序函数)  
无排序函数时，默认升序

        table.sort(t3)
        table.sort(t3, function(a,b)
                if a>b then
                        return true
                end
        end)

4. 拼接         
table.concat(操作表，中间字符，拼接起点，拼接终点)      
无拼接起点终点时，默认从头到尾          
*只能拼接字符串与数字*

        str=table.concat(tb, " ",2,3)
        str=table.concat(t2,"")

### 2.10 脚本相关

#### 1.脚本执行

1. 脚本执行    
会按顺序执行脚本逻辑，如果最后有return会返回反参

        require('脚本名称')
        returnValue=require('脚本名称')
        --得到脚本反参

>脚本只会执行一次，再次执行需要先卸载再执行


2. 查看脚本执行    
返回boolean表示是否执行

        print(package.loaded['脚本名称'])

3. 脚本卸载     
将该loaded置空

        package.loaded["脚本名称"]=nil


#### 2. 本地变量     
在方法或脚本内的变量前加 `local `该变量变为本地变量     
如果没有 `local` 则属于全局变量记录在`_G`表中，在方法体或脚本外也可以访问   

      
>_G表，保存了lua所用的所有全局函数和全局变量

### 2.11 特殊用法

1. 多变量赋值   
多变量赋值秉承了一贯作风，多给的参数舍去，少给的参数nil补上

        a,b,c=1,false,"ghj"

2. 多返回值     
同上

        function Test()
                return 1,2,3,"ghj"
        end
        a,b,c,d,e=Test()


3. and or

        print(1 and false)
        --短路原理，先判断and前是否为真，1为真，返回and后的false

        print(1 or 2)
        --短路原理，先判断1是否为真，1为真，返回1不需要执行or后的2
        print(false or nil)
        --false为假，返回nil

>lua中，只有`nil`和`false`才是假

4. 三目运算     
C#中的三目运算` ? : `是封装好的语法糖,lua中没有实现可以自己通过and or手动实现

        x=3
        y=1
        
        res= (x>y) and x or y 
        --x大于y，为true
        --=> true and x or y
        --true and x 返回x，
        --=> x or y
        --x 为真，返回x
        --达到了（）内为真，返回x的效果

        res= (x<y) and x or y 
        --x不小于y，返回false，
        --=> false and x or y
        --flase and x 返回false
        --=> false or y
        --false跳过，返回y
        --达到了（）内为假，返回y的效果

### 2. 12 协程  
就像C#中的协程，是协同程序，不是线程，分段执行不产生资源抢占

|方法||使用场景|
|--|--|--
|coroutine.create(方法)|创建协程，返回一个thread|创建一个需要监测状态的协程
|coroutine.wrap(方法)|创建协程，返回一个function|快速创建一个不需要监测状态的协程，像funciton一样使用
|coroutine.resume(thread，传参)|执行thread协程|启动thread协程(多次执行都按照第一次的传参执行，后续的参数无法使用，有待深入了解原理)
|function（）|执行协程方法|启动协程方法
|coroutine.yield（可传参）|在协程内声明挂起当前协程，就像Unity中协程的yieldreturn，不过不会自动执行下一步|挂起协程返回当前数据
|coroutine.status(thread)|获取协程的状态(dead,suspended,running)|监控协程的状态，决定是否关闭或开启
|coroutine.running()|获取当前运行的协程号|


### 2.13 元表
任何表变量都可以作为另一个表变量的元表          
任何表变量都可以有自己的元表            
当子表进行特定 操作时，会执行元表的内容  

>[元表与元方法（lua参考手册）](https://www.runoob.com/manual/lua53doc/manual.html#2.4)

#### 1. 设置元表     

设置元表

        meta={}
        myTable={}
        --设置元表
        --（子表，元表）
        setmetatable(myTable,meta)

获取元表

        getmetatable(表名)

#### 2. 运算符重载   
在元表声明对应的funciton，示例代码：

                --运算符+
                __add =function(t1,t2)
                        return t1.age+t2.age
                end,

部分对应运算符表格

|名称|运算符|方法名|备注|
|--|--|--|--|
|加 (add)|+|__add||
|减 (subtract)|-|__sub||
|乘 (multiply)|*|__mul||
|除 (divide)|/|__div||
|取余 (modulo)|%|__mod||
|幂 (power)|^|__pow||
|等于 (equal)|==|__eq||
|小于 (less than)|<|__lt|重载了`<`方法，lua遇到`>`会自动调换入参位置，所有不需要`>`的方法|
|小于等于 (less equal)|<=|__le|同上|
|连接 (connect)|..|__concat||

>所有条件运算符重载都需要两个入参的元表一致        


#### 3. __tostring 方法

        meta2={
                __tostring = function(t)
                        return t.name
                end
        }
        myTable2={
                name="吴彦祖"
        }
        --设置元表
        setmetatable(myTable2,meta2)

        print(myTable2)


#### 3. __call 方法

        meta3={
                __tostring = function(t)
                        return t.name
                end,
                __call = function(a,b)
                        print("表name:"..a.name.."   传入参数:"..b) 
                end

        }
        myTable3 = {
                name="表格名称table3"
        }
        --设置元表
        --（子表，元表）
        setmetatable(myTable3,meta3)
        print(myTable3)
        myTable3(3)

call方法就是给予了该表一个可以调用自己执行的方法，call 的第一个参数是调用者,第二个是外部入参

#### 4. __index __newIndex

"index": 索引 table[key]。 当 table 不是表或是表 table 中不存在 key 这个键时，这个事件被触发。 此时，会读出 table 相应的元方法。
尽管名字取成这样， 这个事件的元方法其实可以是一个函数也可以是一张表。 如果它是一个函数，则以 table 和 key 作为参数调用它。 如果它是一张表，最终的结果就是以 key 取索引这张表的结果。 （这个索引过程是走常规的流程，而不是直接索引， 所以这次索引有可能引发另一次元方法。）

"newindex": 索引赋值 table[key] = value 。 和索引事件类似，它发生在 table 不是表或是表 table 中不存在 key 这个键的时候。 此时，会读出 table 相应的元方法。
同索引过程那样， 这个事件的元方法即可以是函数，也可以是一张表。 如果是一个函数， 则以 table、 key、以及 value 为参数传入。 如果是一张表， Lua 对这张表做索引赋值操作。 （这个索引过程是走常规的流程，而不是直接索引赋值， 所以这次索引赋值有可能引发另一次元方法。）

一旦有了 "newindex" 元方法， Lua 就不再做最初的赋值操作。 （如果有必要，在元方法内部可以调用 rawset 来做赋值。）        

>***以上是lua参考手册内容，等学完课程重新梳理此处概念。***   

自己简言之：            
当子表找不到某属性时，会到元表的__index指定的表找索引，利用index可以向上嵌套，类似于多重继承的效果。        
当赋值时，默认属于index，声明了newindex时，默认属于newindex，再访问这些就需要注明newindex，否则在index找不到newindex的变量。

#### 5. rawget rawset           
rawget会忽略index，在自身寻找变量       

        print(rawget(myTable6,"age"))

rawset会忽略newindex，写入到自己

        rawset(myTable7,"age",2)


### 2.14 模拟面向对象           
1. 声明一个Object表作为基类   

        Object={}

2. Object的实例化方法           
创建一个新表作为实例化类的子表，并返回               

        function Object:new()
                local obj={}
                --给空对象设置元表，和__index
                self.__index=self
                setmetatable(obj,self)
                return obj
        end


3. Object的继承方法
在G表创建记录子类，并设置子类的元表为父类

        function Object:subClass(className)
                --根据名字生成一个表,记录在全局_G表
                _G[className] ={}
                local obj =_G[className]
                --给子表记录父表,命名为base
                obj.base=self

                --给子类设置元表，和__index
                setmetatable(obj,self)
                self.__index=self

        end

4. GameObject继承Object

        Object:subClass("GameObject")

5. GameObjcet实例化

        local obj=GameObject:new()



6. 子类重写方法

        --GameObjcet成员方法
        function GameObject:Move()
                self.posX=self.posX+1
                self.posY=self.posY+1
        end
        --Player继承Gameobjcet
        GameObject:subClass("Player")
        --Player重写Move
        function Player:Move()
                --调用父方法，传入自身
                self.base.Move(self)
                --再写新的PlayerMove逻辑
        end

上面调用父Move时，用 **self.base.Move(self)** 而不是 **self.base:Move()** 。        
使用`.`调用方法时，无默认传参，使用`:`调用方法时，会将调用者传入作为默认参数，对应self  
此处如果使用`:`调用方法，传入的只会是父类GameObjcet，那么每次不同的Player都在共同操作GameObjcet


### 2.15 函数库           
 
#### 1. 时间

        --系统时间(单位s)
        print(os.time())
        --传入日期得到s
        print(os.time({year=2014,month=2,day=3}))
        local nowTime=os.date("*t")
        print(nowTime.min)

#### 2. 数学

        --绝对值
        print(math.abs(-11))
        --弧度转角度
        print(math.deg(math.pi))
        --三角函数,传弧度
        print(math.cos(math.pi))
        --向下取整
        print(math.floor(2.6))
        --向上取整
        print(math.ceil(5.1))
      
        print(math.max(1,2))

        print(math.min(4,5))
        --分离小数，返回整数部分与小数部分
        print(math.modf(1.2))
        --幂运算
        print(math.pow(2,5))

        --随机数，先设置种子
        math.randomseed(os.time())
        --第一个是根据种子本身生成，种子改变了才会改变
        print(math.random(300))
        --第二个是根据种子信息生成，种子信息改变就会改变
        print(math.random(300))
        --开方
        print(math.sqrt(9))

#### 3. 路径

        print(package.path)

并不常用,单独用来调用lua时使用

#### 4. 垃圾回收

        --获取当前lua占用内存数 k字节 用返回值*1024 得到内存占用字节数
        print(collectgarbage("count"))
        --垃圾回收
        collectgarbage("collect")

贴一个剖析XluaGC的博客，抽空再看          
[Unity下XLua方案的各值类型GC优化深度剖析](https://gwb.tencent.com/community/detail/111993)


## 3. xLua

### 3.1 准备阶段
1. xLua框架             
只取用项目中的 `Assets/Plugins` `Assets/Xlua` 文件夹          
[xLua项目地址](https://github.com/Tencent/xLua)         

2. AB包工具             
见专题一1.1部分

3. 单例基类（非必须）     
泛型单例基类，简化单例类的重复声明。            
参考
[SimpleFrameWork](https://github.com/GavinZ233/Learning-SimpleFrameWork)
专题一《单例模式基类》

4. AB包管理器（非必须）         
封装AB包同步异步加载操作，可根据项目重写             
见专题一1.4部分



### 3.2 C#调用Lua

#### 1. Lua解析器       

1. 引用命名空间         

        using XLua;

2. 创建Lua解析器

        LuaEnv luaEnv = new LuaEnv();

3. 执行Lua语言

        //DoString（执行内容，报错信息）
        luaEnv.DoString("print('嗨，你好')", "报错内容："+this.name);

4. 执行Lua脚本  
require默认寻找脚本的路径是在Resources下       
大致是通过Resources.Load加载txt等,而无法读取.lua        
因此Lua脚本后缀要加txt          
文件名：Main.lua.txt

        luaEnv.DoString("require('Main')");

5. 垃圾回收     
清理没有手动释放的对象

        luaEnv.Tick();

6. 关闭Lua解析器        
不常用，解析器一般贯穿项目始终，不会关闭

        luaEnv.Dispose();


#### 2. 文件加载重定向  

1. AddLoader    
其中自定义方法被记录到委托List，如果自定义方法返回空，会一直执行到默认方法

        //xlua提供的路径重定向的方法
        //允许自定义加载Lua文件
        //当我们执行Lua语言require时，相当于执行一个lua脚本
        //他会执行我们自定义传入的函数
        env.AddLoader(MyCustomLoader);
        
2. 自定义加载lua脚本方法

        private byte[] MyCustomLoader(ref string filePath)
        {
                //自定义路径,访问lua文件
                string path=Application.dataPath+"/Lua/"+filePath+".lua";
                Debug.Log(path);
                if (File.Exists(path))
                {
                //读取比特流返回
                return  File.ReadAllBytes(path);
                }
                else
                {
                Debug.Log("MyCustomLoader重定向路径失败，文件名：" + filePath);
                };
                return null;
        }


#### 3. LuaMgr
|名称|作用|操作|
|---|---|---|
|+ LuaTable Global|提供lua的_G|返回luaEnv.Gloabal
|- LuaEnv luaEnv|记录lua解析器|
|+ Init()|初始化方法|初始化lua解析器，为解析器加入lua脚本加载方法
|+ DoLuaFile(string fileName)|通过脚本名称执行lua脚本，避免了每次都require|拼接require与fileName，执行DoString()方法
|+ DoString(string str)|执行lua语言|
|+ Tick()|执行lua垃圾回收|
|+ Dispose()|关闭解析器|dispose解析器，并将本地解析器记录置空
|- byte[] CustomLoader(ref string filePath)|自定义lua文件读取，从Asset下读取|拼接Asset下的lua脚本路径，读取比特流并返回
|- byte[] CustomABLoader(ref string filePath)|定义lua文件读取，从AB包中读取|读取lua文件的AB包，从包中获取TextAsset，返回其中bytes

>AB包中的Lua脚本也需要将后缀名改为txt，鉴于修改后缀与打AB包过程繁琐，日常开发都读取Asset路径下的Lua脚本，测试阶段再统一改后缀打包。     
修改后缀后，第一个CustomLoader读取不到后缀为".lua"的文件，返空，解析器会继续执行CustomABLoader找AB包中的".lua.txt"文件



#### 4. 全局变量的获取

        //初始化解析器
        LuaMgr.GetInstance().Init();
        //执行主脚本
        LuaMgr.GetInstance().DoLuaFile("LuaMain");
        //获取number保存为int
        int i = LuaMgr.GetInstance().Global.Get<int>("testNumber");
        //获取number保存为double
        double d = LuaMgr.GetInstance().Global.Get<double>("testNumber");
        //获取string
        string s = LuaMgr.GetInstance().Global.Get<string>("testString");
        //修改数据
        LuaMgr.GetInstance().Global.Set("testNumber", 66);
        LuaMgr.GetInstance().Global.Set("testString", "修改了string");

>其中数据获取为值拷贝，string也是


#### 5. 全局函数的获取

##### 1. 无参无返回方法               
委托部分：      

        public delegate void CustomCall();
执行部分:               

        CustomCall call = LuaMgr.GetInstance().Global.Get<CustomCall>("testNoINAndOUT");
        call();
        //使用UnityAction
        UnityAction callUA = LuaMgr.GetInstance().Global.Get<UnityAction>("testNoINAndOUT");
        callUA();
        //使用Action
        Action callA = LuaMgr.GetInstance().Global.Get<Action>("testNoINAndOUT");
        callA();
        //Xlua提供的获取方式
        LuaFunction lf = LuaMgr.GetInstance().Global.Get<LuaFunction>("testNoINAndOUT");
        lf.Call();

其中有四种调用方式，使用Action比较方便            

##### 2. 有参有返回方法               
委托部分：      

        [CSharpCallLua]
        public delegate int CustomCall2(int i);
执行部分：

        CustomCall2 call2 = LuaMgr.GetInstance().Global.Get<CustomCall2>("testHasINAndOUT");
         int returnNum = call2(3);
        print(returnNum);


        Func<int,int> sFunc=LuaMgr.GetInstance().Global.Get<Func<int,int>>("testHasINAndOUT");
        int returnsFunc = call2(88);
        print(returnsFunc);

>自定义委托时，需要添加特性`[CSharpCallLua]`，Xlua生成代码向xlua解释器注册委托才能使用,Func是系统提供的委托XLua已经处理过


##### 3. 多返回值方法         
委托部分：      

        [CSharpCallLua]
        public delegate void CustomCall3(int ina, out int a, out string b, out bool c);
        [CSharpCallLua]
        public delegate int CustomCall4(int ina, ref string b, ref bool c);
执行部分：

        CustomCall3 customCall3 = LuaMgr.GetInstance().Global.Get<CustomCall3>("testMultipleOUT");
        int a;
        string b;
        bool c;
        customCall3(1,out a,out b,out c);
        Debug.Log(a+"  "+b+"   "+c);

        CustomCall4 customCall4 = LuaMgr.GetInstance().Global.Get<CustomCall4>("testMultipleOUT");
        int a1=0;
        string b1=null;
        bool c1=false;
        a1 = customCall4(1,  ref b1, ref c1);
        Debug.Log(a1 + "  " + b1 + "   " + c1);

        //Xlua
        LuaFunction lf3 = LuaMgr.GetInstance().Global.Get<LuaFunction>("testMultipleOUT");
        object[] objs=lf3.Call(5);
        for (int i = 0; i < objs.Length; i++)
        {
            Debug.Log(string.Format("第{0}个返回值:" + objs[i], i));
        }

>当定义了委托的返回值时，lua的function第一个返回值就是委托的返回值，从第二个开始才是后续反参

##### 4. 变长入参方法
委托部分：

        [CSharpCallLua]
        public delegate void CustomCall5(params string[] args);
执行方法：

        CustomCall5 customCall5 = LuaMgr.GetInstance().Global.Get<CustomCall5>("testMultipleIn");
        customCall5("asfa", "dasd", "abc");

        LuaFunction lf4 = LuaMgr.GetInstance().Global.Get<LuaFunction>("testMultipleIn");
        lf4.Call("wqe", 321, true);


##### 思考

LuaFunction每种情况都适用，因为该方法的入参和反参都是object[]，就像C#中用arraylist装东西一样，万能但浪费，频繁拆装箱。              
自定义委托需要添加特性之后在窗口XLua=>Generate Code生成代码，让Xlua记录该委托，如果添加新委托，重新生成即可，修改委托则需要先Clear Generate Code再生成。        


#### 6. list和dictionary映射table

##### 1. 数组
lua代码：      

        testList={1,2,3,4,5}
        testArray={"wqe",321,true}
C#代码：

        List<int> list = LuaMgr.GetInstance().Global.Get<List<int>>("testList");
        List<object> list3 = LuaMgr.GetInstance().Global.Get<List<object>>("testArray");


##### 2. 字典
lua代码：      

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


C#代码：

        Dictionary<string, int> dic = LuaMgr.GetInstance().Global.Get<Dictionary<string, int>>("testDic");
        Dictionary<object, object> dic2 = LuaMgr.GetInstance().Global.Get<Dictionary<object, object>>("testDic2");


#####  思考
与获取值相同，都是使用Get方法

>从C#读取lua数据都是深拷贝，在C#创建一份全新的数据，修改C#部分不影响lua部分的数据

#### 7. 类映射table
用lua 的table模拟C#的类         
lua类：

        testClass={
	        testInt=3,
	        testBool=true,
	        testFloat=3.2,
	        testString="qwe",
	        testFun=function()
		        print("testClass打印")
	        end,
	        testInClass={
		        testInInt=123
	        }
        }

C#类：          

        public class CallLuaClass
        {
                public int testInt;
                public bool testBool; 
                public float testFloat;
                public string testString;
                public UnityAction testFun;

                public CallLuaInClass testInClass;
        }

        public class CallLuaInClass
        {
                public int testInInt;
        }


C#调用代码:

        CallLuaClass clc = LuaMgr.GetInstance().Global.Get<CallLuaClass>("testClass");
        clc.testFun();


>C#的成员变量需要与Lua表中的名称一致，名称无法吻合的成员会被忽略        
成员属性中的类也会被一起实例化


#### 8. 接口映射table
lua代码同7                
C#代码:

        [CSharpCallLua]
        public interface ICSharpCallInterface
        {
        public int testInt
        {
                get;
                set;
        }

        public bool testBool
        {
                get;
                set;
        }

        public float testFloat
        {
                get;
                set;
        }
        
        public string testString
        {
                get;
                set;
        }

        public UnityAction testFun
        {
                get;
                set;
        }
        }

>接口内部是属性不是字段，需要加上特性`[CSharpCallLua]`，并且是浅拷贝，通过C#部分修改数据lua部分也会被修改


#### 9. C#调用LuaTable

调用代码：

        //LuTable装table
        LuaTable table = LuaMgr.GetInstance().Global.Get<LuaTable>("testClass");
        //get方法直接执行
        table.Get<LuaFunction>("testFun").Call();
        //使用完释放LuaTable
        table.Dispose();

>xLua提供的LuaTable类，对获取到的数据浅拷贝，C#端修改lua端也会被影响。          
并且调用繁琐，不常用。          


>在自定义委托和接口需要添加CSharpCallLua特性



### 3.3 lua调C#

#### 1. 类
1. 准备         
因为主体是Unity，所以Lua调用C#的前提是，C#先打开Lua     
由此，先创建一个C#的`Main`脚本，负责调用Lua的主脚本`LuaMain`            
后续再用`LuaMain`执行lua逻辑脚本               

2. 调用类       
调用类需要写出路径，`CS`是基础，`UnityEngine`是命名空间，`GameObject`是类名                                        
实例化方法就是该类同名方法，所以直接调用类名就是一次实例化

        --有命名空间
        local obj1=CS.UnityEngine.GameObject("新物体")
        --无命名空间
        local obj2=CS.Test()

3. 静态方法静态变量             
直接在类后面`.`即可

        local findObj =CS.UnityEngine.GameObject.Find("新物体")

4. 成员方法成员变量             
在实例化的类后`.`出成员变量             
在实例化的类后`:`出成员方法，不用`.`是因为成员方法往往需要操作自身，`:`是会传入自身的调用方法

        print(newObj.transform.position)
        findObj.transform:Translate(Vector3.right)

5. 类记录到Global               
可以在_G表记录常用的类，避免每次都要写长串的路径        

        Debug=CS.UnityEngine.Debug
        Vector3=CS.UnityEngine.Vector3
        GameObject =CS.UnityEngine.GameObject
        --使用
        local obj=GameObject()
        Debug.Log(obj.transform.position)



#### 2. 枚举
1. 记录         
像类一样，可以记录到Global      

        --记录枚举的路径
        PrimitiveType=CS.UnityEngine.PrimitiveType
        MyEnum=CS.E_MyEnum

2. 使用
直接点出来内容，就像C#中一样使用

        local obj=GameObject.CreatePrimitive(PrimitiveType.Cube)
        local idle=MyEnum.Idle
        print(idle)

3. 转换
可以由数字和字符串转换到目标枚举                
不同的是，如果找不到目标字符串会报错，找不到目标数字会自动返回一个临时的数字枚举（并不会记录到枚举中，无用的知识增加了）

        local intEnum=MyEnum.__CastFrom(2)
        print(intEnum)

        local stringEnum = MyEnum.__CastFrom("Move")
        print(stringEnum)


#### 3. 数组列表字典
以上数据都是C#的数据结构，被lua读取时，以userdata存储不是table，操作方式需按照C#的方式执行

1. 数组         

        --使用基类Array实例化数组
        local array2=CS.System.Array.CreateInstance(typeof(CS.System.Int32),5)
        print("数组长度： "..array2.Length )
        print("数组内容：  ".. array2[4])
        --遍历，按照C#的逻辑，从0开始，到Length-1
        for i=0,array2.Length-1 do
                print(array2[i])
        end

2. 列表         
特别的当xlua版本低于 v2.1.12时，需要下面方法实例化              
local list3=CS.System.Collections.Generic["List`1[System.String]"]()

        --list是泛型，先记录String类型List
        local List_String=CS.System.Collections.Generic.List(CS.System.String)
        --再实例化
        local list3=List_String() 
        list3:Add("添加元素3")
        --遍历
        for i=0,list3.Count-1 do
                print(list3[i])
        end



3. 字典
当xlua版本低于 v2.1.12时，也需要和列表类似的实例化方法

        --记录字典类
        local Dic_String_Vector3=CS.System.Collections.Generic.Dictionary(CS.System.String,CS.UnityEngine.Vector3)
        --实例化字典
        local dic2=Dic_String_Vector3()
        --调用成员方法
        dic2:Add("right",CS.UnityEngine.Vector3.right)
        --遍历,使用pairs
        for k,v in pairs(dic2) do
                print(k,v)
        end
        --需要通过get_Item方法获得
        print(dic2:get_Item("right"))
        --修改通过set_Item
        dic2:set_Item("right",CS.UnityEngine.Vector3.up)
        print(dic2:get_Item("right"))
        --TryGetValue有两个返回值，一个返回是否成功，一个返回值
        print(dic2:TryGetValue("right3"))


#### 4. 拓展方法

C#代码:         

        [LuaCallCSharp]
        public static class Tools
        {
                //拓展方法需要传入目标类
                public static void Move(this Lesson4 obj)
                {
                        Debug.Log(obj.name + "移动前: "+obj.step);
                        obj.step += 1;
                        Debug.Log(obj.name + "移动后：" +obj.step);
                }
        }

        public class Lesson4
        {
                public string name = "吴彦祖";
                public int step = 0;
                public void Speak(string str)
                {
                        Debug.Log(str);
                }

                public static void Eat()
                {
                        Debug.Log("吃东西");
                }
        }
lua调用：

        --记录类
        Lesson4=CS.Lesson4
        --静态方法，类名.静态方法()
        Lesson4.Eat()
        --实例化
        local obj=Lesson4()
        --执行成员方法
        obj:Speak("开始说话")
        --使用拓展方法和成员方法一致
        obj:Move()


尽量对Lua中要使用的类添加`[LuaCallCSharp]`特性，Xlua会记录该类，避免使用默认的反射机制，反射效率较低


此处引申出Lua与C#调用的深坑，目前搜罗到的博客如下               
[如何实现两门语言互相调用](https://gwb.tencent.com/community/detail/105650)

#### 5. ref和out

在lua中也要遵循C#中的ref和out规则，ref需要传值，out不用，二者都会返回值         

C#代码:

    public int RefFun(int a,ref int b,ref int c,int d)
    {
        b = a + b;
        c = c+d;
        return 100;
    }
    public int OutFun(int a, out int b, out int c, int d)
    {
        b = a + d;
        c = a - d;
        return 200;
    }
    public int RefOutFun(int a, out int b, ref int c)
    {
        b = a *10;
        c = a *20;
        return 300;
    }
lua代码：

        local a,b,c=obj:RefFun(1,1,2,2)
        local a,b,c=obj:OutFun(20,30)
        local a,b,c=obj:RefOutFun(2,1)


>lua调C#时，函数多返回值，第一个值是方法返回值，后面的才是ref与out的返回值


#### 6. 重载函数

lua支持调用C#重载函数，但是当参数个数相同精度不同时，会分不清参数精度             

C#代码：

        public class Lesson6
        {
                public int Calc()
                {
                        return 100;
                }
                public int Calc(int a)
                {
                        return a;
                }
                public int Calc(int a,int b)
                {
                        return a + b;
                }
                public float Calc(float a)
                {
                        return a;
                }
        }


lua调用：

        local obj=CS.Lesson6()

        print(obj:Calc())
        print(obj:Calc(2))
        print(obj:Calc(3,1))
        print(obj:Calc(3.3))
入参3.3时会出问题，因为lua中只有number一种数值类型，而C#有多种，lua分不清`Calc(int a)`与`Calc(float a)`         

有解决重载函数含糊的方法，但不建议使用，实际使用应该避免以上情况。

Xlua提供的反射解决方案:

        --得到指定函数的相关信息
        local m1=typeof(CS.Lesson6):GetMethod("Calc",{typeof(CS.System.Int32)})
        local m2=typeof(CS.Lesson6):GetMethod("Calc",{typeof(CS.System.Single)}) --Float的类名
        --通过xlua提供的方法，转成lua函数使用
        --转一次，重复使用
        local  f1=xlua.tofunction(m1)
        local  f2=xlua.tofunction(m2)
        print(f1(obj,99))
        print(f2(obj,9.9))


#### 7. 委托与事件

##### 7.1 委托

1. 添加委托     

        --lua中不能对nil的委托 + 第一次需要先等于
        obj.del=fun
        obj.del=obj.del+function()
                print("类似的匿名函数")
        end

2. 执行委托

        obj.del()

3. 移除委托

        obj.del=obj.del-fun
        --委托置空
        obj.del=nil


##### 7.2 事件

1. 添加事件     

        obj:eventAction("+",fun2)
        obj:eventAction("+",function()
                print("事件的匿名函数")
        end)

2. 执行事件             
事件不能给外部执行，所以只能执行类内部提供的执行方法

        obj:DoEvent()

3. 移除事件
事件不能给外部直接赋值，所以也需要执行类内部提供的置空方法

        obj:eventAction("-",fun2)
        obj:Clear()


#### 8. 特殊问题

##### 8.1 二维数组遍历

1. 数组的长度获取

        print("行:"..obj.array:GetLength(0))
        print("列:"..obj.array:GetLength(1))


2. 数组的值读取

        print(obj.array:GetValue(0,0))




##### 8.2 null和nil比较

`nil`和`null` 无法`==`比较              

但是可以使用以下三种方法比较    
1. lua的方法
该方法只能判断继承C#的System.Objcet的类

        local rig  = obj1:GetComponent(typeof(Rigidbody))
        if IsNull(rig) then
        	print("无")
        end

2. 自定义一个lua全局方法

        function IsNull(obj)
                if obj==nil or obj:Equals(nil) then
                        return true
                end
                return false
        end

        if rig:Equals(nil) then
                print("无")
        end

3. C#提供Object的拓展方法       
该方法只能判断继承UnityEngine.Objcet的类

        [LuaCallCSharp]
        public static class Lesson9
        {
                public static bool IsNull(this Object obj)
                {
                        return obj == null;
                }
        }

        --lua调用
        if rig:IsNull() then
                print("无")
        end



##### 8.3 lua访问系统类型

lua无法直接使用系统类型float，int等，提示需要添加call的特性，而系统类型无法修改。             
由此引出新的方法:               
将需要两个语言互相调用的类型全部添加到对应的list当中，给list添加特性，整个list就会被lua记录下来

        public static class Lesson10
        {
                [CSharpCallLua]
                public static List<Type> csharpCallLuaList = new List<Type>()
                {
                        typeof(UnityAction<float>)
                        //自定义委托也可以加载列表中，都会被特性标注记录到xlua中
                };

                [LuaCallCSharp]
                public static List<Type> luaCallCSharpList = new List<Type>()
                {
                        typeof(GameObject),
                        typeof(Rigidbody)
                };
        }

xlua参考文档:                   
[xLua的配置](https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/configure.md)
#### 9. 协程
lua的function无法直接传入Unity的协程执行，需要使用xlua提供的工具`util`转换          


前置准备：

        --记录GameObject
        GameObject =CS.UnityEngine.GameObject
        --Unity的yield类
        WaitForSeconds=CS.UnityEngine.WaitForSeconds
        --xlua提供给的工具表
        util=require("xlua.util")

        --创建一个物体
        local obj=GameObject("Coroutine")
        --添加Mono脚本
        local mono=obj:AddComponent(typeof(CS.LuaCallCSharp))


声明协程方法：

        fun=function()
                local i=1
                while i<11 do
                        --yield返回Unity的类WaitForSeconds
                        coroutine.yield(WaitForSeconds(1))
                        print(i)
                        i=i+1
                        if i>3 then
                                --停止本协程
                                mono:StopCoroutine(co)
                        end
                end
        end



调用协程：      
执行Unity协程方法时，需要使用`util`的方法`cs_generator`转换fun

        co =mono:StartCoroutine(util.cs_generator(fun))


#### 10. 泛型函数

默认情况下lua仅支持调用C#`有参有约束的函数`，且约束只能是`Class`           

调用:   

        --有约束有参，直接传入参数
        obj:TestFun1(child,father)
        obj:TestFun1(father,child)

当需要使用其他情况的泛型时，需要在新版xlua下使用                        
xlua.get_generic_method(目标类,泛型方法名称)            

        --记录泛型方法
        local testFun2 =xlua.get_generic_method(Lesson,"TestFun2")
        --设置泛型类型
        local testFun2_int =testFun2(CS.System.Int32)

        --成员方法第一个参数传对象，静态方法不用传
        --执行泛型方法
        testFun2_int(obj,3)

>需要注意这种方法在Mono打包时，可以正常使用。             
Il2cpp时，要考虑泛型是否被剔除的问题，引用类型正常使用，值类型需要C#调用过同类型的泛型参数，lua才能使用，不然就会被il2cpp自动剔除，导致lua无法访问

此处需要复习il2cpp打包的知识，自动剔除的知识有些模糊            
[C#补充课程-IL2Cpp问题处理](https://www.taikr.com/course/1374/task/48323/show)


## 4. Hotfix

适用于已有的完全C#项目进行lua热补丁             
可以使用lua逻辑顶替以往的C#逻辑         
[xlua热补丁操作指南](https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/hotfix.md)
### 4.1 准备工作         

1. Tools工具文件夹      
路径:           
`xLua-master`==>`Tools`         
复制到Unity项目父文件夹下即可:           
`xxProject/Tools  `

2. 加入热修复宏         
路径：                  
`File`==>`Build Settings`==>`Project Settings`==>`Player`==>`Other Settings`==>`Scripting Define Symbols`               
添加 `HOTFIX_ENABLE` 并应用             
**官方提示** ：          
建议平时开发业务代码不打开HOTFIX_ENABLE                  
编辑器、各手机平台这个宏要分别设置！                      
自动化打包在代码用API设置宏不生效，需要在编辑器设置。


### 4.2 第一个热补丁     

1. 特性                 
C#被热修复的脚本需要添加 `[Hotfix]` 特性


2. 编写lua热补丁代码   
热补丁固定写法`xlua.hotfix(被补丁类，被补丁函数名，lua补丁函数)`      
成员方法要增加`self`入参，静态方法不需要      
示例：

        --声明补丁方法
        hf_GetAge=function (self)
                return self.age
        end
        --注册补丁
        xlua.hotfix(CS.HotfixTest,"GetAge",hf_GetAge)

3. 生成代码           
`Xlua`==>`GenerateCode`         
每当新 **添加** 修复类或者方法时，都需要 **重新生成代码** 


4. Hotfix注入           
路径:           
`Xlua`==>`Hotfix Inject In Editor`              
注入时如果提示没有`Tools`那就是忘记做`4.1准备工作的1.Tools工具文件夹`步骤或者文件路径放错了。           
每当被修复类内容 **修改** 时，都需要 **重新注入** 


### 4.3 多函数替换
多个函数一起替换时，调用:               
 `xlua.hotfix(被修复类,{被替换方法1=lua方法1，被替换方法2=lua方法2} `            
代码示例：              

        xlua.hotfix(CS.HotfixTest2,{

                --构造函数热补丁，固定写法 [".ctor"]
                [".ctor"]=function ()
                        print("热补丁后的构造函数")
                end,
                Speak=function(self,a)
                        print("热补丁后的Speak："..a)
                end,
                --析构函数固定写法 Finalize
                Finalize=function ()
                        -- body
                end
        })
以上，构造函数固定写法`[".ctor"]`，构析函数固定写法`Finalize`。          
构造、构析两个函数的热补丁只能在原有逻辑之后执行，不能替换原有逻辑，                    
其他函数都是替换原有逻辑                         



### 4.4 协程函数替换

1. 引用xlua 的转换工具类        
用来转换lua协程给C#

        util=require("xlua.util")



2. 定义补丁协程函数             
此函数的逻辑替换原有协程的逻辑

        hf_Coroutine=function ()
			while true do
				coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
				print("lua补丁后的协程打印")
			end
        end

3.  定义协程转换函数    
通过util转换lua函数返回给C#

        hf_TransformCo=function (self)          
			--返回一个xlua处理过的lua协程函数
		        return util.cs_generator(hf_Coroutine)
        end


4. 替换协程函数         
将`3`的转换函数替换原有的协程

        xlua.hotfix(CS.HotfixMain,{
                TestCoroutine=hf_TransformCo
        })

>实际也可以将以上三个函数嵌套在一起写，不过有些混乱。            
建议将转换函数与补丁函数合并，写成下面样子:

        hf_Coroutine=function (self)          
                --返回一个xlua处理过的lua协程函数
                --此匿名函数用来顶替原有C#协程
                return util.cs_generator(function()
                        while true do
                                coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
                                print("lua补丁后的协程打印")
                        end
                end)
        end


        xlua.hotfix(CS.HotfixMain,{
                TestCoroutine=hf_Coroutine
        })

### 4.5 访问器索引器替换
本章节在原有的知识基础上，只需要注意名称。                
访问器set方法`set_属性名`，get方法`get_属性名`             
索引器set方法`set_Item`，get方法`get_Item`              
并且都是`成员方法`，记得加入参数`self`
#### 1. 访问器替换

原有C#访问器:           

    public int Age
    {
        get
        {return 0;}
        set
        {Debug.Log(value);}
    }

lua补丁访问器:

	--set_属性名  set方法
	--get_属性名  get方法
	set_Age=function (self,v)
		print("lua重定向的set")
	end,
	get_Age=function (self,v)
		return 99
	end,



#### 2. 索引器替换


原有C#索引器:           

    public int this[int index]
    {
        get
        {
            if (index < 0||index>=array.Length)
            {
                Debug.LogWarning("索引不正确");
                return 0;
            }
            return array[index];
        }
        set
        {
            if (index < 0 || index >= array.Length)
            {
                Debug.LogWarning("索引不正确");
                return;
            }
             array[index]= value;

        }
    }




lua补丁索引器:

	--set_Item  索引器设置
	--get_Item  索引器获取
	set_Item=function (self,index,v)
		print("lua重定向set"..index.."值："..v)
	end,
	get_Item=function (self,index)
		return 99
	end



### 4.6 事件加减
使用场景较少           

添加方法`add_事件名称`             
移除方法`remove_事件名称`

需要注意：添加方法被重定向后，就无法正常添加了，不能继续调用C#的添加方法，会造成死循环，一般是将函数存在lua中

lua补丁代码:

        add_myEvent=function (self,del)
                print(del)
                print("添加事件函数")
        end,
        remove_myEvent=function (self,del)
                print(del)
                print("移除事件函数")
        end


### 4.7 泛型类替换

泛型类T是不确定的，lua中要将每个类型都替换

        xlua.hotfix(CS.HotfixGenericity(CS.System.String),{
                Test=function (self,t)
                        print("lua补丁打印："..t)
                end
        })

        xlua.hotfix(CS.HotfixGenericity(CS.System.Int32),{
                Test=function (self,t)
                        print("lua补丁打印："..t)
                end
        })









## 5. xLua的背包系统

### 1. 准备工作

#### 1. Asset Bundle Browser                 
2020版本以下直接在UnityPackageMgr搜索，                 
2020版本以上打开UnityPackageMgr，点+号选择URL导入： `https://github.com/Unity-Technologies/AssetBundles-Browser.git`

#### 2. xlua         
以下文件夹复制到项目根目录      
`Plugins`,`Xlua`

#### 3. C#基础代码（非必须）                 
单例基类，AB包管理器，Lua解析器管理器


#### 4. lua基础代码（非必须）                        
lua面向对象逻辑，lua json工具脚本，字符串拆分脚本


#### 5. C#主脚本             
挂载在场景上，负责调用lua主脚本即可

传送到地方

#### 6. VSCode插件     
1. 美化     
Material Icon Theme                    
Guides          
background


    "background.fullscreen": {

        "images": ["https://file.moyublog.com/d/file/2022-10-10/06eb592b69286f9dc9cbb50d3c320357.jpg"],
        "opacity": 0.85,
        "size": "cover",
        "position": "center",
        "interval": 0
    }


2. 功能                 
Chinese         
C#              
C# XML Documentation Comments  `///`快速注释               
Unity Snippets          
Auto-Using for C#               
Debugger for Unity（已经弃用改用Unity）                


3. Unity调试配置                     
`Debugger for Unity`已经被弃用，导致只能用`Unity`，且只支持2019以上版本Unity。                  
如果依然选择老版本Unity可能需要参考该方法，自己没尝试                   
[VS Code里使用Debugger for Unity插件进行调试(2023最新版)](https://blog.csdn.net/nick1992111/article/details/128580845)                 
新版本也需要进入`Package Manager`升级`Visual Studio Editor`到最新版，然后去首选项选择VSCode。             
Unity调试前需要创建配置文件`launch.json`，在文件内添加:


        {
            "name": "Unity调试",
            "type": "vstuc",
            "request": "attach"
        }


1. Lua调试配置                  
vscode插件`EmmyLua`，作用是调试lua，但需要java的jdk。                     
课程中的jdk是`jdk-1.8-64`版本。                 
然后配置java环境：                      
进入系统属性，环境变量                
系统变量添加                
变量名：JAVA_HOME                
变量值：`C:\Program Files\Java\jdk1.8.0_191`           
变量名：CLASSPATH                
变量值：`.;%Java_Home%\bin;%Java_Home%\lib\dt.jar;%Java_Home%\lib\tools.jar`           
环境变量的Path新建`%JAVA_HOME%\bin`         
最后在配置文件`launch.json`添加:              

        {
            "type": "emmylua_attach",
            "request": "attach",
            "name": "Lua附加Unity",
            "pid": 0,
            "processName": ""
        }



### 2.UI准备            
拼UI太基础，就不做操作记录了。                        
1. 主面板               
拼接出一个主面板`MainPanel`             
有两个按钮`btnSkill` `btnRole`           

1. 背包面板             
背包面板`BagPanel`              
内容：背景图`bg`，关闭按钮`btnClose`，                  
Toggle组`toggleGroup`，包含：`togEquip` `togItem` `togGem`                
还有一个物品的scrollview，记得在content上加`GridLayoutGroup`和`ContentSizeFitter`

1. 物品格子     
物品格子`ItemGrid`              
自上向下：图片`bg`物品图标`icon`数量文本`num`



### 3. lua基础类                

1. 面向对象的模拟类     

2. 字符串根据分隔符拆分的脚本
   
3. JsonUtility.lua

4. 初始化脚本                   
   负责调用以上三个脚本，和提前记录所有常用的C#类 

### 4. 数据准备

#### 1. 编写一些json数据，提供给背包item             

#### 2. 将icon打包成图集

#### 3. 将预制体、json、图集打AB包                   
打AB如果报lua相关的错，记得先清空xlua代码再打包

#### 4. lua读json

首先构建了两个脚本：            
1. ItemData             
   调用`ABMgr`加载json的AB包得到`TextAsset`，再通过lua这边预先调用的`JsonUtility`decode成表，           
   将表的内容按照`id：item信息表`的格式存在全局表`ItemData`中           
2. PlayerData           
   玩家信息表`PlayerData`，内部存储三个小表：`equips` `items` `gems`，每个表都记录相关的id与数量。            
   初始化方法`Init`用来获取玩家数据信息,将信息填入到玩家信息表中，目前数据是在方法里直接写死的，后面可以换成从外部读取。                



### 5. 主面板MainPanel

|名称|类型|作用|
|--|--|--|
|MainPanel|表|当作本面板的类，记录面板与按钮
|panelObj|表|记录本面板GameObject
|btnRole|表|记录角色面板按钮
|btnSkill|表|记录技能面板按钮
|MainPanel:Init|方法|初始化面板，实例化面板与按钮，并传入点击事件
|MainPanel:ShowMe|方法|初始化面板，显示面板
|MainPanel:HideM|方法|隐藏面板
|MainPanel:BtnRoleClic|方法|点击事件
|MainPanel:BtnSkillClick|方法|点击事件


**注意:**                   
在调用按钮的`onClick:AddListener()`时，传入的是方法，只能如下：     

        self.btnRole.onClick:AddListener(self.BtnRoleClick)

此时面对一个问题：方法`BtnRoleClick`内部没有传入`self`，也即在外部调用时，访问不到主面板的成员。            
保持该思路，就需要在方法`BtnRoleClick`内部修改:                 

        function  MainPanel:BtnRoleClick()
                print(MainPanel.panelObj)
        end

这样可以通过全局变量`MainPanel`访问主面板的成员，但有些绕圈子，也违背了面向对象的思想。      

**解决方法：**                 
可以在调用按钮的`onClick:AddListener()`时，将传入的方法套在匿名函数内，保持方法可以传入`self`。                 

    self.btnRole.onClick:AddListener(function ()
        self:BtnRoleClick()
    end)


### 6. 背包面板BagPanel

|名称|类型|作用|
|--|--|--|
|BagPanel|表|当作本面板的类，记录面板与按钮
|panelObj|表|记录本面板GameObject
|btnClose|表|记录关闭按钮
|togEquip|表|记录装备复选框
|togItem|表|记录物品复选框
|togGem|表|记录宝石复选框
|svBag|表|记录滚动框
|Content|表|记录物品容器Transform
|BagPanel:Init|方法|初始化面板，实例化面板与按钮，并传入点击事件
|BagPanel:ShowMe|方法|初始化面板，显示面板
|BagPanel:HideM|方法|隐藏面板
|BagPanel:ChangeType(type)|方法|根据点击的复选框切换下方滚动框内容


**注意:**   

此处的Toggle事件`onValueChanged:AddListener(value)`有参数，需要标注`[CSharpCallLua]`特性，但碍于无法添加，使用一个静态类创建静态列表记录类型，帮助xlua生成对应的解释代码         

        public static class CSharpCallLuaList
        {
                [CSharpCallLua]
                public static List<Type> cSharpCallLuaList=new List<Type>()
                { 
                        typeof(UnityAction<bool>)
                };
        }


### 7. 物品格子ItemGrid

依靠已有的面向对象模拟脚本，实现一个`ItemGrid`类                

        Object:subClass("ItemGrid")


|名称|类型|作用|
|--|--|--|
|ItemGrid.obj|表|记录场景中的物品格子
|ItemGrid.icon|表|记录格子的图标
|ItemGrid.num|表|记录格子的数量文本
|ItemGrid:Init(father,posX,posY)|方法|实例化物品格子，记录控件，设置父物体与位置
|ItemGrid:InitData(data)|方法|读取数据，更新格子的图标与数量
|ItemGrid:Destroy()|方法|删除对应的物品格子，并置空引用


>此背包只是跟随唐老师的思路制作，后续自行制作时应该注意：其中的数据名称命名方式可以写得详细一些，避免认知混乱，预制体也可以更加丰富，满足多种定制化，比如背景图和环绕特效等。             



### 8. 面板基类







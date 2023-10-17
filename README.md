# Learning-Lua
lua课程学习笔记



## 整体结构

|节点|内容|难点
|--|--|--
|AB包||
|Lua语法||
|xLua||
|toLua||
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
|**Copy to StreamingAssets**|输出的ab包复制给SA一份|
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
当赋值时，默认属于index，声明了newindex时，默认属于newindex，再访问这些就需要注明newindex

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












## 4. toLua


## 5. xLua的背包系统



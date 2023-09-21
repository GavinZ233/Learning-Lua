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


## 3. xLua


## 4. toLua


## 5. xLua的背包系统



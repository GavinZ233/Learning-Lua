# Learning-Lua
lua课程学习笔记

all right 

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
|文件|作用|
|--|--|
|包名.分组名|ab包本体|
|manifest|ab包的关联信息，资源信息，版本信息等|
|和导出文件夹同名|ab包的主包,记录依赖关系|

#### 1.2.4 UnityLearn对于AB包的介绍




### 1.3 使用AB包资源





### 1.4 AB包资源加载Mgr







## 2. Lua语法


## 3. xLua


## 4. toLua


## 5. xLua的背包系统



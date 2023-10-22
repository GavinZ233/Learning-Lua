using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using XLua;

public class Lesson7_CallClass : MonoBehaviour
{
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("LuaMain");

        CallLuaClass clc = LuaMgr.GetInstance().Global.Get<CallLuaClass>("testClass");
        clc.testFun();
        print(clc.testInt+"     "+clc.testFloat+"        " + clc.testBool + "        " + clc.testString + "        ");
        print("嵌套类：" + clc.testInClass.testInInt);


        print("------------接口-------------");
        ICSharpCallInterface icci = LuaMgr.GetInstance().Global.Get<ICSharpCallInterface>("testClass");
        icci.testFun();
        print(icci.testInt + "     " + icci.testFloat + "        " + icci.testBool + "        " + icci.testString + "        ");
        icci.testInt = 0;
        print(LuaMgr.GetInstance().Global.Get<ICSharpCallInterface>("testClass").testInt);

    }

    void Update()
    {
        

    }
}


public class CallLuaClass
{
    public int testInt;
    public bool testBool; 
    public float testFloat;
    public string testString;

    public CallLuaInClass testInClass;

    public UnityAction testFun;

    //成员变量一定要和lua目标table的命名一致
    //公共变量才能赋值，私有无法赋值
    //lua中没有的变量或者多余的变量，都会忽略赋值

}

public class CallLuaInClass
{
    public int testInInt;
}

//接口内不允许写字段,接口内都是属性，不是字段，接table需要添加特性，接口是浅拷贝，
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




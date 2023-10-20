using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using XLua;

public delegate void CustomCall();

//有参有反回的自定义委托需要加特性标识（无参无返回的被系统处理过了），xlua会根据特性生成对应的lua代码，Xlua-Generate Code
[CSharpCallLua]
public delegate int CustomCall2(int i);
[CSharpCallLua]
public delegate void CustomCall3(int ina, out int a, out string b, out bool c);
[CSharpCallLua]
public delegate int CustomCall4(int ina, ref string b, ref bool c);
//当定义了委托的返回值时，lua的function第一个返回值就是委托的返回值，从第二个开始才是后续反参

[CSharpCallLua]
public delegate void CustomCall5(params string[] args);


public class Lesson5_CallFunction : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("LuaMain");

        //*****************无参无返回***********************
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

        //*****************有参有返回***********************
        CustomCall2 call2 = LuaMgr.GetInstance().Global.Get<CustomCall2>("testHasINAndOUT");
         int returnNum = call2(3);
        print(returnNum);


        Func<int,int> sFunc=LuaMgr.GetInstance().Global.Get<Func<int,int>>("testHasINAndOUT");
        int returnsFunc = call2(88);
        print(returnsFunc);



        //*****************多返回值***********************


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


        //*****************变长参数***********************


        CustomCall5 customCall5 = LuaMgr.GetInstance().Global.Get<CustomCall5>("testMultipleIn");
        customCall5("asfa", "dasd", "abc");

        LuaFunction lf4 = LuaMgr.GetInstance().Global.Get<LuaFunction>("testMultipleIn");
        lf4.Call("wqe", 321, true);



    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

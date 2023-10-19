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











        //*****************变长参数***********************








    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
